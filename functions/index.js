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

    console.log('Returning mock diet programs');

    // Always return mock diet programs for now to ensure app works
    const mockPrograms = {
      programs: [
        {
          id: "program1",
          name: "Klasik Dengeli Diyet",
          dailyCalories: 1800,
          description: "Günlük yaşamınızda kolayca uygulayabileceğiniz dengeli bir beslenme programı.",
          dailyMeals: {
            breakfast: "Yulaf ezmesi, muz ve ceviz",
            lunch: "Izgara tavuk, bulgur pilavı ve salata",
            dinner: "Balık, sebze yemeği ve yoğurt",
            snacks: "Meyve ve fındık"
          },
          weeklyPlan: "Haftanın 6 günü aynı öğün yapısını koruyun, 1 gün serbest bırakın.",
          nutritionTargets: {
            protein: 120,
            carbs: 200,
            fat: 60
          },
          tips: [
            "Günde en az 2 litre su için",
            "Öğünlerinizi düzenli saatlerde yiyin",
            "Ara öğünleri ihmal etmeyin"
          ],
          notes: "Bu program genel bir örnektir. Kişisel ihtiyaçlarınıza göre doktorunuza danışın."
        },
        {
          id: "program2",
          name: "Esnek Akdeniz Diyeti",
          dailyCalories: 1900,
          description: "Akdeniz mutfağı esinlenilen, daha esnek bir beslenme yaklaşımı.",
          dailyMeals: {
            breakfast: "Tam tahıllı ekmek, zeytin, peynir ve domates",
            lunch: "Mercimek çorbası, pilav ve yoğurt",
            dinner: "Kırmızı et, patates ve brokoli",
            snacks: "Yoğurt ve meyve"
          },
          weeklyPlan: "Haftada 2-3 kez et, diğer günlerde balık veya sebze ağırlıklı yemekler.",
          nutritionTargets: {
            protein: 110,
            carbs: 220,
            fat: 65
          },
          tips: [
            "Zeytinyağı tüketimini artırın",
            "Kırmızı et tüketimini haftada 2-3 güne sınırlayın",
            "Mevsim sebzelerini tercih edin"
          ],
          notes: "Sosyal hayatınızı etkilemeyecek kadar esnek bir program."
        },
        {
          id: "program3",
          name: "Hızlı Sonuç Odaklı Program",
          dailyCalories: 1600,
          description: "Daha hızlı sonuç almak isteyenler için kontrollü kalori programı.",
          dailyMeals: {
            breakfast: "Yeşil çay, az yağlı peynir ve tam tahıllı ekmek",
            lunch: "Ton balığı salatası ve sebze çorbası",
            dinner: "Izgara tavuk göğsü ve bol yeşillik",
            snacks: "Protein bar ve elma"
          },
          weeklyPlan: "Haftada 5 gün düşük kalori, 2 gün normal kalori günü uygulayın.",
          nutritionTargets: {
            protein: 130,
            carbs: 150,
            fat: 50
          },
          tips: [
            "Porsiyon kontrolü çok önemli",
            "Düzenli egzersiz yapın",
            "Uyku düzeninizi koruyun"
          ],
          notes: "Hızlı kilo kaybı için uygundur ama doktor kontrolünde uygulanmalı."
        }
      ]
    };
    return res.json(mockPrograms);
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
