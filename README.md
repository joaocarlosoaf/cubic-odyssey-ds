# Cubic Odyssey Dedicated Server - Docker

A complete Docker solution to host a dedicated **Cubic Odyssey** game server using containers.

## 📋 Prerequisites

- **Docker** and **Docker Compose** installed
- Valid **Steam account** (to download server files)
- **Steam Guard Mobile Authenticator** configured (if account has 2FA)
- At least **2GB** of free disk space

## 🚀 Quick Setup

### 1. Clone or download the project
```bash
git clone <repository-url>
cd cubic-odyssey-ds
```

### 2. Configure environment variables
```bash
cp .env.example .env
nano .env
```

### 3. Configure your Steam credentials
Edit the `.env` file with your information:

```env
# Steam credentials (required)
STEAM_USER=your_steam_username
STEAM_PASS=your_steam_password
STEAM_AUTH=

# Server settings
SERVER_NAME=My Cubic Odyssey Server
SERVER_PASSWORD=server_password
MAX_PLAYERS=10
GAME_MODE=SURVIVAL
```

### 4. Run the server
```bash
docker-compose up -d
```

## ⚙️ Available Settings

All configurations are made through the `.env` file:

| Variable | Default | Description |
|----------|---------|-------------|
| `STEAM_USER` | - | **Required**: Steam username |
| `STEAM_PASS` | - | **Required**: Steam password |
| `STEAM_AUTH` | - | Steam Guard code (if requested) |
| `SERVER_NAME` | `Cubic Odyssey Dedicated Server (Docker)` | Server name |
| `SERVER_PASSWORD` | - | Server password (leave empty for public) |
| `MAX_PLAYERS` | `8` | Maximum number of players |
| `GAME_MODE` | `ADVENTURE` | Game mode (`ADVENTURE`, `CREATIVE`, `SURVIVAL`) |
| `PRIVATE_SERVER` | `FALSE` | Private server (`TRUE`/`FALSE`) |
| `GALAXY_SEED` | `21945875634` | Universe seed |
| `STARTING_PORT` | `27001` | Starting port |
| `ENDING_PORT` | `27015` | Ending port |
| `ENABLE_CRASH_DUMPS` | `FALSE` | Enable crash dumps |
| `ALLOW_RELAYING` | `FALSE` | Allow connection relaying |
| `ENABLE_LOGGING` | `FALSE` | Enable detailed logging |

## 🔧 Useful Commands

### Start server
```bash
docker-compose up -d
```

### View logs in real time
```bash
docker-compose logs -f
```

### Stop server
```bash
docker-compose down
```

### Rebuild image (after changes)
```bash
docker-compose build --no-cache
docker-compose up -d
```

### Access server console
```bash
docker exec -it cubic-odyssey-ds bash
```

## 🌐 Connecting to the Server

### In Cubic Odyssey game:
1. Open the game
2. Go to **Multiplayer**
3. Look for your server name in the list
4. Or use the **Lobby Key** that appears in the logs

### Find the Lobby Key:
```bash
docker-compose logs | grep "Lobby Key"
```

You'll see something like:
```
Lobby Key: DS-ABCDEF
```

## 📁 Project Structure

```
cubic-odyssey-ds/
├── Dockerfile              # Docker image configuration
├── docker-compose.yml      # Container orchestration
├── start.sh                # Server initialization script
├── .env                    # Environment variables (settings)
├── .env.example            # Configuration template
├── data/                   # Persistent server data
│   ├── config/             # Configuration files
│   ├── steamcmd/           # SteamCMD files
│   └── server/             # Game files
└── README.md               # This file
```

## 🛠️ Troubleshooting

### Steam Guard / 2FA
If your account has two-factor authentication:
1. The server will pause asking for mobile confirmation
2. Open the Steam Mobile app and confirm the login
3. The server will continue automatically

### Permission errors
```bash
sudo chown -R 1000:1000 data/
```

### Reconfigure server
```bash
# Remove existing configuration
rm -f data/config/server_config.txt
docker-compose restart
```

### Detailed logs
```bash
# View complete logs
docker-compose logs

# View only errors
docker-compose logs | grep ERROR
```

### Ports in use
If ports 27001-27015 are occupied, change in `.env`:
```env
STARTING_PORT=28001
ENDING_PORT=28015
```

And update `docker-compose.yml`:
```yaml
ports:
  - "28001-28015:28001-28015/udp"
```

## 📊 Monitoring

### Server status
```bash
docker-compose ps
```

### Resource usage
```bash
docker stats cubic-odyssey-ds
```

### Data backup
```bash
tar -czf backup-$(date +%Y%m%d).tar.gz data/
```

## 🔒 Security

- Container runs as non-privileged user
- Only necessary ports are exposed
- Sensitive data stays in `.env` file (don't version this file!)

## 📝 Important Notes

1. **First run**: May take time to download game files (~1GB)
2. **Steam Guard**: Keep your phone nearby during first setup
3. **Backup**: Regularly backup the `data/` folder
4. **Updates**: Server checks for updates automatically on startup

## 🆘 Support

If you encounter problems:
1. Check the logs: `docker-compose logs`
2. Verify settings in `.env`
3. Check if ports are available
4. Try rebuilding: `docker-compose build --no-cache`

---

**Developed to simplify Cubic Odyssey server hosting using Docker** 🐋