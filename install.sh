#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== Claude Code CS 1.6 Sound Effects Installer ==="
echo ""

# Create sounds directory
mkdir -p "$SOUNDS_DIR"

# Copy sounds
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR"/sounds/*.wav "$SOUNDS_DIR/"
echo "[OK] Sounds copied to $SOUNDS_DIR"

# Hooks configuration
HOOKS='{
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/locknload.wav &"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/rounddraw.wav &"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/ctwin.wav &"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/ct_reportingin.wav &"
          }
        ]
      },
      {
        "matcher": "ExitPlanMode",
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/bombdef.wav &"
          }
        ]
      }
    ],
    "Elicitation": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/com_reportin.wav &"
          }
        ]
      }
    ],
    "PostToolUseFailure": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/ct_imhit.wav &"
          }
        ]
      }
    ],
    "SubagentStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/com_go.wav &"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/roger.wav &"
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/ct_backup.wav &"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/ct_affirm.wav &"
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/enemydown.wav &"
          }
        ]
      }
    ]
  }'

# Check if settings.json exists
if [ -f "$SETTINGS_FILE" ]; then
  # Check if hooks already exist
  if grep -q '"hooks"' "$SETTINGS_FILE"; then
    echo ""
    echo "[WARNING] Your settings.json already has a \"hooks\" section."
    echo "To avoid overwriting your config, the hooks have been saved to:"
    echo "  $SCRIPT_DIR/hooks.json"
    echo ""
    echo "Please merge them manually into: $SETTINGS_FILE"
    echo "$HOOKS" > "$SCRIPT_DIR/hooks.json"
  else
    # Add hooks to existing settings using a temp file
    TMP=$(mktemp)
    # Remove trailing } and add hooks
    sed '$ d' "$SETTINGS_FILE" > "$TMP"
    echo '  ,"hooks": '"$HOOKS" >> "$TMP"
    echo '}' >> "$TMP"
    mv "$TMP" "$SETTINGS_FILE"
    echo "[OK] Hooks added to $SETTINGS_FILE"
  fi
else
  # Create new settings.json
  mkdir -p "$HOME/.claude"
  echo '{"hooks": '"$HOOKS"'}' > "$SETTINGS_FILE"
  echo "[OK] Created $SETTINGS_FILE with hooks"
fi

echo ""
echo "=== Installation complete! ==="
echo "Restart Claude Code to activate the sounds."
echo ""
echo "Test a sound: afplay $SOUNDS_DIR/locknload.wav"
