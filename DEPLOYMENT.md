# Deployment Guide - Tarkov Sound Trainer with High Scores

## Quick Start (Docker)

To deploy the complete application with high scores:

```bash
# Stop any existing containers
docker-compose down

# Rebuild and start
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

Access at: `http://localhost:32082` (or your configured port)

## Architecture

The application now consists of two services:

### 1. Frontend (Nginx)
- **Container**: `tarkov-sound-game`
- **Port**: 32082 (external) → 80 (internal)
- **Purpose**: Serves static files (HTML, CSS, JS, images, audio)
- **Location**: `./public/` directory

### 2. Backend (Node.js/Express)
- **Container**: `tarkov-sound-backend`
- **Port**: 3000 (internal only)
- **Purpose**: High scores API
- **Endpoints**:
  - `GET /api/highscores` - Fetch top 10 scores
  - `POST /api/highscores/check` - Check if score qualifies
  - `POST /api/highscores` - Submit new high score

### Communication
- Nginx proxies `/api/*` requests to the backend
- Both services communicate via Docker network `tarkov-network`
- High scores stored in `highscores.json` (persisted via volume mount)

## File Structure

```
tarkov-sound-game/
├── docker-compose.yml      # Orchestrates both services
├── Dockerfile              # Backend container definition
├── nginx.conf              # Nginx configuration with API proxy
├── server.js               # Express backend
├── package.json            # Node.js dependencies
├── highscores.json         # Persistent high score storage
└── public/                 # Static frontend files
    ├── index.html
    ├── js/
    │   └── game.js         # Uses relative /api/ URLs
    └── ...
```

## Configuration

### Change Port
Edit `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:80"  # Change YOUR_PORT
```

### Backend Environment
Edit `docker-compose.yml`:
```yaml
environment:
  - PORT=3000  # Backend internal port
```

## Troubleshooting

### High Scores Not Working

1. **Check backend is running**:
   ```bash
   docker-compose ps
   ```
   Both containers should be "Up"

2. **Check backend logs**:
   ```bash
   docker-compose logs backend
   ```
   Should show: "Server running on http://localhost:3000"

3. **Check API connectivity**:
   ```bash
   curl http://localhost:32082/api/highscores
   ```
   Should return: `[]` or high scores JSON

4. **Check browser console**:
   - Open DevTools (F12)
   - Look for errors in Console tab
   - Check Network tab for failed API requests

### Permission Issues

If `highscores.json` has permission errors:
```bash
chmod 666 highscores.json
docker-compose restart backend
```

### Rebuild After Changes

After modifying code:
```bash
docker-compose down
docker-compose up -d --build
```

## Maintenance

### View High Scores File
```bash
cat highscores.json
```

### Clear High Scores
```bash
echo "[]" > highscores.json
docker-compose restart backend
```

### Update Application
```bash
git pull
docker-compose down
docker-compose up -d --build
```

## Production Deployment

For production, consider:

1. **Use environment variables for sensitive data**
2. **Add rate limiting to API endpoints**
3. **Set up HTTPS with Let's Encrypt**
4. **Configure proper logging**
5. **Set up monitoring/alerts**
6. **Regular backups of highscores.json**

Example production docker-compose.yml additions:
```yaml
services:
  backend:
    environment:
      - NODE_ENV=production
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Backup High Scores

```bash
# Backup
cp highscores.json highscores.backup.json

# Restore
cp highscores.backup.json highscores.json
docker-compose restart backend
```










