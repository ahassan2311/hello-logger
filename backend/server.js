const express = require('express');
const app = express();
const PORT = process.env.PORT || 4000;

// ✅ Required to parse JSON bodies
app.use(express.json());

app.post('/api/log', (req, res) => {
  const { message } = req.body;
  console.log("📥 Log received:", message);
  res.json({ status: '✅ Message received by backend!' });
});

app.listen(PORT, () => {
  console.log(`🚀 Backend running on port ${PORT}`);
});