#!/usr/bin/env bash
set -euo pipefail

SERVER_DIR="${SERVER_DIR:-/server}"
STEAMCMD_DIR="${SERVER_DIR}/steamcmd"

SRCDS_APPID="${SRCDS_APPID:-3858450}"

# Defaults de config
STARTING_PORT="${STARTING_PORT:-27001}"
ENDING_PORT="${ENDING_PORT:-27015}"
SERVER_NAME="${SERVER_NAME:-Cubic Odyssey Dedicated Server (Docker)}"
SERVER_PASSWORD="${SERVER_PASSWORD:-}"
MAX_PLAYERS="${MAX_PLAYERS:-8}"
GAME_MODE="${GAME_MODE:-ADVENTURE}"
PRIVATE_SERVER="${PRIVATE_SERVER:-FALSE}"
GALAXY_SEED="${GALAXY_SEED:-21945875634}"
ENABLE_CRASH_DUMPS="${ENABLE_CRASH_DUMPS:-FALSE}"
ALLOW_RELAYING="${ALLOW_RELAYING:-FALSE}"
ENABLE_LOGGING="${ENABLE_LOGGING:-FALSE}"

mkdir -p "${SERVER_DIR}" "${STEAMCMD_DIR}" "${SERVER_DIR}/steamapps" "${SERVER_DIR}/config"

STEAM_USER="${STEAM_USER:-anonymous}"
STEAM_PASS="${STEAM_PASS:-}"
STEAM_AUTH="${STEAM_AUTH:-}"

echo "[1/4] Installing SteamCMD (if needed)..."
if [[ ! -f "${STEAMCMD_DIR}/steamcmd.sh" ]]; then
  tmp="$(mktemp -d)"
  curl -fsSL -o "${tmp}/steamcmd.tar.gz" \
    "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
  tar -xzf "${tmp}/steamcmd.tar.gz" -C "${STEAMCMD_DIR}"
  rm -rf "${tmp}"
fi

echo "[2/4] Updating/installing Cubic Odyssey Dedicated Server (AppID ${SRCDS_APPID})..."
cd "${STEAMCMD_DIR}"

./steamcmd.sh \
  +force_install_dir "${SERVER_DIR}" \
  +login "${STEAM_USER}" "${STEAM_PASS}" "${STEAM_AUTH}" \
  +@sSteamCmdForcePlatformType windows \
  +app_update "${SRCDS_APPID}" validate \
  +quit

CONFIG_FILE="${SERVER_DIR}/config/server_config.txt"

echo "[3/4] Ensuring config: ${CONFIG_FILE}"

if [[ -f "${CONFIG_FILE}" ]]; then
  echo " - Removing existing config to regenerate with new variables..."
  rm "${CONFIG_FILE}"
fi

echo " - Generating new configuration file..."
cat > "${CONFIG_FILE}" <<EOF
GameParams
{
	m_server ServerParams
	{
		startingPort ${STARTING_PORT}
		endingPort ${ENDING_PORT}
		serverName "${SERVER_NAME}"
		serverPassword "${SERVER_PASSWORD}"
		maxPlayers ${MAX_PLAYERS}
		gameMode ${GAME_MODE}
		privateServer ${PRIVATE_SERVER}
		galaxySeed ${GALAXY_SEED}
		enableCrashDumps ${ENABLE_CRASH_DUMPS}
		allowRelaying ${ALLOW_RELAYING}
		enableLogging ${ENABLE_LOGGING}
	}
}
EOF

echo "[4/4] Starting server..."
cd "${SERVER_DIR}"

# Executável esperado conforme receita do egg
exec wine ./server/CubicOdysseyServer.exe
