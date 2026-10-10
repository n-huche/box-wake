#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p "$HOME/.local/bin" "$HOME/Library/LaunchAgents"
cp box-wake.sh "$HOME/.local/bin/box-wake.sh"; chmod +x "$HOME/.local/bin/box-wake.sh"
cp com.nicolas.box-wake.plist "$HOME/Library/LaunchAgents/"
launchctl bootout "gui/$(id -u)/com.nicolas.box-wake" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.nicolas.box-wake.plist"
echo "instalado. log: ~/Library/Logs/box-wake.log"
