#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== Claude Code CS 1.6 Sound Effects Uninstaller ==="
echo ""

# Remove sounds
if [ -d "$SOUNDS_DIR" ]; then
  rm -rf "$SOUNDS_DIR"
  echo "[OK] Removed $SOUNDS_DIR"
else
  echo "[SKIP] No sounds directory found"
fi

# Remove hooks from settings
if [ -f "$SETTINGS_FILE" ]; then
  echo ""
  echo "[INFO] To remove hooks, edit $SETTINGS_FILE and delete the \"hooks\" section."
  echo "       Or delete the file entirely: rm $SETTINGS_FILE"
else
  echo "[SKIP] No settings.json found"
fi

echo ""
echo "=== Uninstall complete! ==="
