const express = require('express');
const multer = require('multer');
const fs = require('fs');
const axios = require('axios');
const bodyParser = require('body-parser');
const OpenAI = require('openai');

const upload = multer({ dest: '/tmp/' });
const app = express();
app.use(bodyParser.json());

// Environment variables to set:
// NUTRITIONIX_APP_ID, NUTRITIONIX_APP_KEY, OPENAI_API_KEY (veya LLM_API_KEY)
// LLM_MODEL_NAME: Kullanılacak model adı (örn: 'gpt-oss-120b', 'gpt-4o-mini', 'o1-preview')
// LLM_API_BASE_URL: Özel API base URL (gpt-oss-120B için gerekli olabilir, OpenAI API formatında olmalı)
// LLM_REASONING_EFFORT: 'low', 'medium', 'high' (gpt-oss modelleri için)

// Estimate calories endpoint:
app.post('/estimate-calories', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'No image uploaded' });
    const imagePath = req.file.path;

    // 1) Use a label detection API (Google Vision / Clarifai) to get detected food labels.
    // For simplicity, this example does a naive approach: call Google Vision REST API via axios
    // You may need to set GOOGLE_APPLICATION_CREDENTIALS or use an API key.

    // Replace with your Vision API call. Here we demonstrate a placeholder labels array.
    const labels = await detectLabelsPlaceholder(imagePath);

    // 2) For each label, query Nutritionix / Edamam to get calories for a typical portion
    const nutritionixAppId = process.env.NUTRITIONIX_APP_ID;
    const nutritionixAppKey = process.env.NUTRITIONIX_APP_KEY;

    if (!nutritionixAppId || !nutritionixAppKey) {
      // Return labels so front-end can at least show detected items
      return res.json({ calories: null, items: labels, warning: 'Nutritionix keys not configured' });
    }

    let totalCalories = 0;
    const items = [];
    for (const label of labels) {
      try {
        const q = encodeURIComponent(label);
        const url = `https://trackapi.nutritionix.com/v2/natural/nutrients`;
        const r = await axios.post(url, { query: label }, {
          headers: {
            'x-app-id': nutritionixAppId,
            'x-app-key': nutritionixAppKey,
            'Content-Type': 'application/json'
          }
        });

        if (r.data && r.data.foods && r.data.foods.length > 0) {
          const food = r.data.foods[0];
          const kcal = food.nf_calories || 0;
          totalCalories += kcal;
          items.push({ label, calories: kcal });
        } else {
          items.push({ label, calories: null });
        }
      } catch (err) {
        items.push({ label, calories: null, error: err.message });
      }
    }

    // Cleanup
    try { fs.unlinkSync(imagePath); } catch (e) { }

    return res.json({ calories: Math.round(totalCalories), items });
  } catch (err) {
    return res.status(500).json({ error: err.toString() });
  }
});

// Simple placeholder label detection (replace with real Vision API call)
async function detectLabelsPlaceholder(imagePath) {
  // In production: call Google Vision or Clarifai to get labels from image.
  // For demo, return a couple of likely food labels.
  return ['rice', 'chicken', 'salad'];
}

// Generate personalized program endpoint
app.post('/generate-plan', async (req, res) => {
  try {
    const profile = req.body;
    const openaiKey = process.env.OPENAI_API_KEY;
    if (!openaiKey) return res.status(400).json({ error: 'OPENAI_API_KEY not set' });

    // Use OpenAI or any LLM to create a plan based on profile
    // This is a placeholder that returns a simple based-on-profile string.

    const plan = `Kişisel plan (örnek):\nHedef: ${profile.goal}\nAktivite: ${profile.activityLevel}\nGünlük kalori hedefi: ...`;
    return res.json({ plan });
  } catch (err) {
    return res.status(500).json({ error: err.toString() });
  }
});

// Generate multiple diet program alternatives based on user answers
app.post('/generate-diet-programs', async (req, res) => {
  try {
    const { programKey, answers, userProfile } = req.body;
    
    // Model ve API yapılandırması - environment variable'lardan alınır
    const apiKey = process.env.OPENAI_API_KEY || process.env.LLM_API_KEY;
    const modelName = process.env.LLM_MODEL_NAME || 'gpt-4o-mini'; // Default OpenAI model
    const apiBaseUrl = process.env.LLM_API_BASE_URL; // Eğer özel bir API base URL varsa (örn: gpt-oss-120B için)
    const reasoningEffort = process.env.LLM_REASONING_EFFORT || 'medium'; // gpt-oss için: 'low', 'medium', 'high'
    
    if (!apiKey) {
      return res.status(400).json({ error: 'OPENAI_API_KEY or LLM_API_KEY not set' });
    }

    // OpenAI client'ı - eğer custom base URL varsa onu kullan
    const openaiConfig = {
      apiKey: apiKey
    };
    if (apiBaseUrl) {
      openaiConfig.baseURL = apiBaseUrl;
    }
    
    const openai = new OpenAI(openaiConfig);

    // Create a comprehensive prompt for OpenAI
    const programTypeLabels = {
      'lose': 'Kilo Verme',
      'gain': 'Kilo Alma',
      'maintain': 'Kilo Koruma',
      'fitness': 'Aktif Spor'
    };

    const programLabel = programTypeLabels[programKey] || programKey;
    
    let prompt = `Sen bir beslenme uzmanısın. ${programLabel} hedefi olan bir kullanıcı için 3 farklı alternatif diyet programı oluştur.

Kullanıcı Profili:
- Yaş: ${userProfile?.age || 'Bilinmiyor'}
- Boy: ${userProfile?.height || 'Bilinmiyor'} cm
- Kilo: ${userProfile?.weight || 'Bilinmiyor'} kg
- Aktivite Seviyesi: ${userProfile?.activityLevel || 'Bilinmiyor'}

Sorular ve Cevaplar:\n`;

    // Add answers to prompt
    for (const [key, value] of Object.entries(answers)) {
      prompt += `- ${key}: ${JSON.stringify(value)}\n`;
    }

    prompt += `\nHer bir diyet programı için şunları içermelidir:
1. Program Adı (kısa ve açıklayıcı)
2. Günlük kalori hedefi
3. Günlük öğün planı (sabah, öğle, akşam, ara öğünler)
4. Haftalık yemek örnekleri ve alternatifleri
5. Besin değerleri hedefi (protein, karbonhidrat, yağ gramları)
6. Pratik ipuçları ve öneriler
7. Dikkat edilmesi gerekenler

Her program farklı bir yaklaşım sunmalı:
- Program 1: Klasik ve dengeli yaklaşım
- Program 2: Daha esnek ve pratik yaklaşım
- Program 3: Daha hızlı sonuç odaklı yaklaşım (sağlıklı sınırlar içinde)

Yanıtını JSON formatında ver. Format şöyle olmalı:
{
  "programs": [
    {
      "id": "program1",
      "name": "Program Adı",
      "dailyCalories": 1800,
      "description": "Kısa açıklama",
      "dailyMeals": {
        "breakfast": "Örnek kahvaltı menüsü",
        "lunch": "Örnek öğle yemeği menüsü",
        "dinner": "Örnek akşam yemeği menüsü",
        "snacks": "Ara öğün önerileri"
      },
      "weeklyPlan": "Haftalık plan açıklaması",
      "nutritionTargets": {
        "protein": 120,
        "carbs": 200,
        "fat": 60
      },
      "tips": ["İpucu 1", "İpucu 2", "İpucu 3"],
      "notes": "Dikkat edilmesi gerekenler"
    },
    ... (2 program daha)
  ]
}

Sadece JSON yanıt ver, başka açıklama ekleme.`;

    // Model parametreleri - gpt-oss-120B için reasoning_effort parametresi eklenir
    const completionParams = {
      model: modelName,
      messages: [
        {
          role: 'system',
          content: 'Sen bir beslenme uzmanısın. Kullanıcılar için sağlıklı, dengeli ve kişiselleştirilmiş diyet programları oluşturuyorsun. Yanıtların her zaman JSON formatında olmalı.'
        },
        {
          role: 'user',
          content: prompt
        }
      ],
      temperature: 0.7,
      max_tokens: 4000
    };

    // gpt-oss modelleri için reasoning_effort parametresi eklenir
    if (modelName.includes('gpt-oss') || modelName.includes('o1')) {
      completionParams.reasoning_effort = reasoningEffort;
    }

    const completion = await openai.chat.completions.create(completionParams);

    const content = completion.choices[0].message.content;
    
    // Try to parse JSON from the response
    let jsonResponse;
    try {
      // Sometimes OpenAI wraps JSON in markdown code blocks
      const jsonMatch = content.match(/```json\s*([\s\S]*?)\s*```/) || content.match(/```\s*([\s\S]*?)\s*```/);
      const jsonString = jsonMatch ? jsonMatch[1] : content;
      jsonResponse = JSON.parse(jsonString);
    } catch (parseError) {
      // If parsing fails, try to extract JSON from the content
      try {
        jsonResponse = JSON.parse(content);
      } catch (e) {
        console.error('Failed to parse OpenAI response:', content);
        return res.status(500).json({ error: 'Failed to parse AI response', raw: content });
      }
    }

    return res.json(jsonResponse);
  } catch (err) {
    console.error('Error generating diet programs:', err);
    return res.status(500).json({ error: err.toString() });
  }
});

// Start server for local testing
if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Server running on ${port}`));
}

module.exports = app;
