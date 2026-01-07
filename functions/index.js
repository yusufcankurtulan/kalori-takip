const express = require('express');
const multer = require('multer');
const fs = require('fs');
const axios = require('axios');
const bodyParser = require('body-parser');

const upload = multer({ dest: '/tmp/' });
const app = express();
app.use(bodyParser.json());

// Environment variables to set:
// NUTRITIONIX_APP_ID, NUTRITIONIX_APP_KEY, OPENAI_API_KEY

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

// Start server for local testing
if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Server running on ${port}`));
}

module.exports = app;
