# Tarkov Weapon Sound Trainer

A round-based guessing game to learn how to identify Escape from Tarkov weapons by their sound.

**Repository:** [https://github.com/folken88/tarkov_audio_game](https://github.com/folken88/tarkov_audio_game)

## Setup

1. **Start the Docker container:**
   ```bash
   docker-compose up -d
   ```

2. **Access the game:**
   - Local: `http://localhost:32082`
   - Domain: `https://tarkov.folkengames.com` (after DNS configuration)

## Adding Audio Files

Audio files should be organized in the following structure:

```
public/audio/
  {weapon-id}/
    {range}/
      {filename}.mp3
```

### Example:
```
public/audio/
  ak-74/
    close/
      shot1.mp3
      shot2.mp3
    medium/
      shot1.mp3
      shot2.mp3
    far/
      shot1.mp3
      shot2.mp3
  m4a1/
    close/
      shot1.mp3
    medium/
      shot1.mp3
    far/
      shot1.mp3
```

### Range Categories:
- `close` - Close range shots
- `medium` - Medium range shots
- `far` - Long range shots

### File Naming:
- Use descriptive names like `shot1.mp3`, `shot2.mp3`, etc.
- Supported formats: MP3, OGG, WAV

## Game Features

- **Round-based gameplay**: Each round plays a random weapon sound
- **8 choices**: 1 correct answer, 7 incorrect
- **Scoring**: 10 points per correct answer
- **Streak tracking**: Track consecutive correct answers
- **Replay audio**: Listen to the sound multiple times before answering

## Configuration

- **Port**: Default port is `32082` (can be changed in `docker-compose.yml`)
- **Domain**: Configure DNS to point `tarkov.folkengames.com` to your server

## Notes

- The game will work with placeholder audio paths until you add actual audio files
- Weapon list includes all major weapons from Escape from Tarkov
- Audio files are cached for better performance


