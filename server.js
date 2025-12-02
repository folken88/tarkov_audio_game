const express = require('express');
const fs = require('fs').promises;
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
const HIGHSCORES_FILE = path.join(__dirname, 'highscores.json');

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Initialize highscores file if it doesn't exist
async function initHighscores() {
  try {
    await fs.access(HIGHSCORES_FILE);
  } catch {
    await fs.writeFile(HIGHSCORES_FILE, JSON.stringify([]));
  }
}

// Get high scores
app.get('/api/highscores', async (req, res) => {
  try {
    const data = await fs.readFile(HIGHSCORES_FILE, 'utf8');
    const highscores = JSON.parse(data);
    res.json(highscores);
  } catch (error) {
    console.error('Error reading highscores:', error);
    res.status(500).json({ error: 'Failed to read highscores' });
  }
});

// Submit a new high score
app.post('/api/highscores', async (req, res) => {
  try {
    const { name, score, seed } = req.body;
    
    if (!name || typeof score !== 'number') {
      return res.status(400).json({ error: 'Invalid data' });
    }
    
    // Sanitize name (max 20 chars, alphanumeric + spaces)
    const sanitizedName = name.trim().substring(0, 20).replace(/[^a-zA-Z0-9 ]/g, '');
    
    if (!sanitizedName) {
      return res.status(400).json({ error: 'Invalid name' });
    }
    
    // Sanitize seed (max 30 chars, alphanumeric + hyphens)
    const sanitizedSeed = seed ? seed.trim().substring(0, 30).replace(/[^a-zA-Z0-9-]/g, '') : 'unknown';
    
    // Read current highscores
    const data = await fs.readFile(HIGHSCORES_FILE, 'utf8');
    let highscores = JSON.parse(data);
    
    // Add new score
    const newEntry = {
      name: sanitizedName,
      score: score,
      seed: sanitizedSeed,
      date: new Date().toISOString()
    };
    
    highscores.push(newEntry);
    
    // Sort by score (descending) and keep top 10
    highscores.sort((a, b) => b.score - a.score);
    highscores = highscores.slice(0, 10);
    
    // Save back to file
    await fs.writeFile(HIGHSCORES_FILE, JSON.stringify(highscores, null, 2));
    
    res.json({ success: true, highscores });
  } catch (error) {
    console.error('Error saving highscore:', error);
    res.status(500).json({ error: 'Failed to save highscore' });
  }
});

// Check if a score qualifies for top 10
app.post('/api/highscores/check', async (req, res) => {
  try {
    const { score } = req.body;
    
    if (typeof score !== 'number') {
      return res.status(400).json({ error: 'Invalid score' });
    }
    
    const data = await fs.readFile(HIGHSCORES_FILE, 'utf8');
    const highscores = JSON.parse(data);
    
    // Check if score qualifies for top 10
    const qualifies = highscores.length < 10 || score > highscores[highscores.length - 1].score;
    
    res.json({ qualifies });
  } catch (error) {
    console.error('Error checking highscore:', error);
    res.status(500).json({ error: 'Failed to check highscore' });
  }
});

// Start server
initHighscores().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
});

