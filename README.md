# Tarkov Weapon Sound Trainer

A round-based guessing game to learn how to identify Escape from Tarkov weapons by their sound.

**✨ Fully accessible for blind and visually impaired users with keyboard navigation and screen reader support!**

**Live Demo:** [https://tarkov.folkengames.com](https://tarkov.folkengames.com)  
**Repository:** [https://github.com/folken88/tarkov_audio_game](https://github.com/folken88/tarkov_audio_game)

## Accessibility

This game is **fully playable without a mouse or visual display**:
- **Arrow keys** to navigate weapon choices
- **Enter** to select
- **Automatic screen reader announcements** for all game events
- **Audio cues** for correct/incorrect answers
- Complete keyboard shortcuts for all game functions

See [ACCESSIBILITY.md](ACCESSIBILITY.md) for full documentation.

## Installation

### Option 1: Docker Deployment (Recommended)

The easiest way to deploy with full high score functionality:

1. **Install Docker and Docker Compose**
2. **Clone the repository**:
   ```bash
   git clone https://github.com/folken88/tarkov_audio_game.git
   cd tarkov_audio_game
   ```
3. **Start the containers**:
   ```bash
   docker-compose up -d
   ```
4. **Access the game** at `http://localhost:32082`

This deploys:
- Nginx frontend serving static files
- Node.js backend for high scores API
- Persistent storage for leaderboard

To stop:
```bash
docker-compose down
```

To view logs:
```bash
docker-compose logs -f
```

### Option 2: Manual Installation with High Scores

1. **Install Node.js** (v14 or higher)
2. **Install dependencies**:
   ```bash
   npm install
   ```
3. **Start the server**:
   ```bash
   npm start
   ```
4. **Access the game** at `http://localhost:3000`

The server provides:
- Static file serving
- High score API with persistent storage
- CORS support for development

### Option 3: Static Deployment (No High Scores)

1. **Copy the `public/` directory** to your web server's document root
2. **Access the game** through your web browser

**Note**: High scores will not work without the Node.js backend.

### Example Deployment Locations:
- Apache: `/var/www/html/tarkov-trainer/`
- Nginx: `/usr/share/nginx/html/tarkov-trainer/`
- Any static file hosting service (GitHub Pages, Netlify, etc.)

### Requirements:
- **With High Scores**: Node.js v14+, Express, CORS
- **Static Only**: Any web server capable of serving static files
- Modern web browser with JavaScript enabled

## Game Features

- **Round-based gameplay**: 50 rounds maximum per game
- **8 choices**: 1 correct answer, 7 incorrect
- **Dynamic scoring**: 
  - 5-10 points per correct answer (based on replays)
  - Double points for single-shot identification
  - -1 point for skipping
  - -2 points for wrong answers
- **Streak tracking**: Track consecutive correct answers
- **Replay audio**: Listen to sounds multiple times (points decrease with each replay)
- **Skip rounds**: Skip if you don't know (-1 point penalty)
- **Audio effects**: Optional environmental audio effects (distance, helmet muffling, through walls)
- **Round history**: Track your performance across all rounds
- **High scores**: Top 10 leaderboard with persistent storage
- **Gallery view**: Browse all weapons with their images and audio files

## Project Structure

```
public/
  ├── index.html          # Main game page
  ├── gallery.html        # Weapon gallery/diagnostic view
  ├── css/
  │   └── styles.css      # Game styling
  ├── js/
  │   ├── game.js         # Game logic
  │   ├── weapons.js      # Weapon data
  │   ├── gallery.js      # Gallery page logic
  │   └── audio-effects.js # Audio processing
  ├── weapons/
  │   └── {weapon-id}/
  │       ├── {WeaponName}.png  # Weapon image
  │       ├── close/            # Close range audio
  │       ├── medium/           # Medium range audio
  │       └── far/              # Far range audio
  └── images/
      └── weapons/              # Additional weapon images
```

## Adding New Weapons

1. **Add weapon to `public/js/weapons.js`:**
   ```javascript
   { id: 'weapon-id', name: 'Weapon Name' }
   ```

2. **Create weapon folder structure:**
   ```
   public/weapons/weapon-id/
     ├── Weapon-Name.png
     ├── close/
     ├── medium/
     └── far/
   ```

3. **Add audio files** to the appropriate range folders (close/medium/far)

4. **Update audio mappings** in `public/js/game.js` and `public/js/gallery.js`:
   ```javascript
   'weapon-id': ['weapons/weapon-id/medium/sound1.mp3', 'weapons/weapon-id/medium/sound2.mp3']
   ```

5. **Add weapon to enabled list** in `public/js/game.js`:
   ```javascript
   const WEAPONS_WITH_AUDIO = [
     // ... other weapons
     'weapon-id',
   ];
   ```

## Development & Testing

For local development and testing, you can use Docker (optional):

```bash
docker-compose up -d
```

This will serve the game at `http://localhost:32082`

Alternatively, use any local web server:
- Python: `python -m http.server 8000`
- Node.js: `npx http-server public/`
- PHP: `php -S localhost:8000 -t public/`

## Notes

- All weapons from Escape from Tarkov are included in the weapon list
- Currently **32 weapons have audio** and are playable in the game
- Audio files are cached by the browser for better performance
- The game works entirely client-side with no backend required


