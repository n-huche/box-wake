#!/bin/bash
launchctl bootout "gui/$(id -u)/com.nicolas.box-wake" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.nicolas.box-wake.plist" "$HOME/.local/bin/box-wake.sh"
echo "removido"
