#!/usr/bin/env bash
# MiniMax Quick Setup Script for Clawdbot
# Usage: ./setup-minimax.sh [your-api-key]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="${HOME}/.clawdbot/clawdbot.json"
CONFIG_DIR="${HOME}/.clawdbot"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       MiniMax Setup for Clawdbot                         ║${NC}"
echo -e "${BLUE}║  Supports: M2.1, M2.1-lightning, M2                      ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print colored messages
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if clawdbot is installed
if ! command -v clawdbot &> /dev/null; then
    error "Clawdbot is not installed. Please install it first:"
    echo "  npm install -g clawdbot@latest"
    exit 1
fi

success "Clawdbot is installed"

# Get API key
API_KEY=""
if [ $# -ge 1 ]; then
    API_KEY="$1"
else
    echo ""
    info "Please enter your MiniMax API key"
    echo "  Get it from: ${BLUE}https://platform.minimax.io${NC}"
    read -p "API Key (starts with sk-): " API_KEY
fi

# Validate API key format
if [[ ! "$API_KEY" =~ ^sk- ]]; then
    error "Invalid API key format. MiniMax keys should start with 'sk-'"
    exit 1
fi

success "API key validated"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Choose configuration mode
echo ""
info "Choose configuration mode:"
echo "  ${GREEN}1${NC}) All three models (M2.1 + M2.1-lightning + M2) ${YELLOW}[Recommended]${NC}"
echo "  ${GREEN}2${NC}) M2.1 only (latest, best quality)"
echo "  ${GREEN}3${NC}) M2.1-lightning priority (speed focus)"
echo "  ${GREEN}4${NC}) Mixed with Claude Opus (requires Anthropic key)"
read -p "Enter choice (1-4) [1]: " choice
choice=${choice:-1}

# Backup existing config
if [ -f "$CONFIG_FILE" ]; then
    warning "Existing config found. Creating backup..."
    cp "$CONFIG_FILE" "${CONFIG_FILE}${BACKUP_SUFFIX}"
    success "Backup created: ${CONFIG_FILE}${BACKUP_SUFFIX}"
fi

# Generate configuration based on choice
case $choice in
    1)
        info "Setting up all three MiniMax models..."
        CONFIG_CONTENT=$(cat <<EOF
{
  "env": {
    "MINIMAX_API_KEY": "${API_KEY}"
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "model": {
        "primary": "minimax/MiniMax-M2.1",
        "fallbacks": [
          "minimax/MiniMax-M2.1-lightning",
          "minimax/MiniMax-M2"
        ]
      },
      "models": {
        "minimax/MiniMax-M2.1": { "alias": "M2.1" },
        "minimax/MiniMax-M2.1-lightning": { "alias": "Lightning" },
        "minimax/MiniMax-M2": { "alias": "M2" }
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimaxi.com/anthropic",
        "apiKey": "\${MINIMAX_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "MiniMax-M2.1",
            "name": "MiniMax M2.1",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2.1-lightning",
            "name": "MiniMax M2.1 Lightning",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2",
            "name": "MiniMax M2",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "gateway": {
    "port": 18789,
    "bind": "loopback"
  }
}
EOF
)
        ;;
    2)
        info "Setting up M2.1 only..."
        CONFIG_CONTENT=$(cat <<EOF
{
  "env": {
    "MINIMAX_API_KEY": "${API_KEY}"
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "model": {
        "primary": "minimax/MiniMax-M2.1"
      },
      "models": {
        "minimax/MiniMax-M2.1": { "alias": "Minimax" }
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimaxi.com/anthropic",
        "apiKey": "\${MINIMAX_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "MiniMax-M2.1",
            "name": "MiniMax M2.1",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
EOF
)
        ;;
    3)
        info "Setting up M2.1-lightning priority..."
        CONFIG_CONTENT=$(cat <<EOF
{
  "env": {
    "MINIMAX_API_KEY": "${API_KEY}"
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "model": {
        "primary": "minimax/MiniMax-M2.1-lightning",
        "fallbacks": ["minimax/MiniMax-M2.1", "minimax/MiniMax-M2"]
      },
      "models": {
        "minimax/MiniMax-M2.1-lightning": { "alias": "Lightning" },
        "minimax/MiniMax-M2.1": { "alias": "M2.1" },
        "minimax/MiniMax-M2": { "alias": "M2" }
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimaxi.com/anthropic",
        "apiKey": "\${MINIMAX_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "MiniMax-M2.1-lightning",
            "name": "MiniMax M2.1 Lightning",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2.1",
            "name": "MiniMax M2.1",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2",
            "name": "MiniMax M2",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
EOF
)
        ;;
    4)
        info "Setting up mixed Claude + MiniMax..."
        read -p "Enter your Anthropic API key: " ANTHROPIC_KEY
        CONFIG_CONTENT=$(cat <<EOF
{
  "env": {
    "ANTHROPIC_API_KEY": "${ANTHROPIC_KEY}",
    "MINIMAX_API_KEY": "${API_KEY}"
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "model": {
        "primary": "anthropic/claude-opus-4-5",
        "fallbacks": [
          "minimax/MiniMax-M2.1",
          "minimax/MiniMax-M2.1-lightning"
        ]
      },
      "models": {
        "anthropic/claude-opus-4-5": { "alias": "Opus" },
        "minimax/MiniMax-M2.1": { "alias": "M2.1" },
        "minimax/MiniMax-M2.1-lightning": { "alias": "Lightning" }
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimaxi.com/anthropic",
        "apiKey": "\${MINIMAX_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "MiniMax-M2.1",
            "name": "MiniMax M2.1",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2.1-lightning",
            "name": "MiniMax M2.1 Lightning",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 15, "output": 60, "cacheRead": 2, "cacheWrite": 10 },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
EOF
)
        ;;
    *)
        error "Invalid choice"
        exit 1
        ;;
esac

# Write configuration
echo "$CONFIG_CONTENT" > "$CONFIG_FILE"
success "Configuration written to $CONFIG_FILE"

# Verify configuration
echo ""
info "Verifying configuration..."
if clawdbot config get > /dev/null 2>&1; then
    success "Configuration is valid"
else
    error "Configuration validation failed"
    warning "Restoring backup..."
    if [ -f "${CONFIG_FILE}${BACKUP_SUFFIX}" ]; then
        mv "${CONFIG_FILE}${BACKUP_SUFFIX}" "$CONFIG_FILE"
        success "Backup restored"
    fi
    exit 1
fi

# Test the models
echo ""
info "Testing MiniMax connection..."
if clawdbot models status > /dev/null 2>&1; then
    success "MiniMax provider is configured correctly"
else
    warning "Could not verify MiniMax status (this might be normal)"
fi

# Print next steps
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                   Setup Complete! 🎉                      ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "  1. Start the gateway:"
echo "     ${GREEN}clawdbot gateway run${NC}"
echo ""
echo "  2. Test your setup:"
echo "     ${GREEN}clawdbot agent --message 'Hello from MiniMax!'${NC}"
echo ""
echo "  3. List available models:"
echo "     ${GREEN}clawdbot models list${NC}"
echo ""
echo "  4. Switch models (in chat):"
echo "     ${GREEN}/model${NC}"
echo ""
echo "  5. View documentation:"
echo "     ${BLUE}https://docs.clawd.bot/providers/minimax-models-guide${NC}"
echo ""
echo -e "${YELLOW}Pro Tips:${NC}"
echo "  • Use ${GREEN}/model M2.1${NC} to quickly switch models"
echo "  • Use ${GREEN}/model Lightning${NC} for faster responses"
echo "  • Use ${GREEN}/usage full${NC} to track token usage"
echo "  • Add more models anytime in ${BLUE}~/.clawdbot/clawdbot.json${NC}"
echo ""
if [ -f "${CONFIG_FILE}${BACKUP_SUFFIX}" ]; then
    echo -e "${YELLOW}Note:${NC} Your previous config was backed up to:"
    echo "  ${BLUE}${CONFIG_FILE}${BACKUP_SUFFIX}${NC}"
    echo ""
fi
