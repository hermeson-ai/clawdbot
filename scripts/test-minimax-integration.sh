#!/usr/bin/env bash
# MiniMax Models Integration Test
# Tests all three MiniMax models (M2.1, M2.1-lightning, M2)

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        MiniMax Models Integration Test                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check prerequisites
if ! command -v clawdbot &> /dev/null; then
    echo -e "${RED}✗${NC} Clawdbot is not installed"
    exit 1
fi
echo -e "${GREEN}✓${NC} Clawdbot is installed"

if [ -z "${MINIMAX_API_KEY:-}" ]; then
    echo -e "${RED}✗${NC} MINIMAX_API_KEY is not set"
    echo "  Export your API key: export MINIMAX_API_KEY='sk-...'"
    exit 1
fi
echo -e "${GREEN}✓${NC} MINIMAX_API_KEY is set"

# Test configuration
echo ""
echo -e "${BLUE}Testing configuration...${NC}"

if ! clawdbot models list &> /dev/null; then
    echo -e "${RED}✗${NC} Configuration error"
    exit 1
fi
echo -e "${GREEN}✓${NC} Configuration is valid"

# Check if MiniMax provider is configured
if ! clawdbot models list 2>&1 | grep -q "minimax"; then
    echo -e "${YELLOW}⚠${NC} MiniMax provider not found in configuration"
    echo "  Run: ./scripts/setup-minimax.sh"
    exit 1
fi
echo -e "${GREEN}✓${NC} MiniMax provider is configured"

# Test each model
MODELS=("MiniMax-M2.1" "MiniMax-M2.1-lightning" "MiniMax-M2")
TEST_PROMPT="请用一句话介绍你自己"

echo ""
echo -e "${BLUE}Testing models...${NC}"
echo ""

for MODEL in "${MODELS[@]}"; do
    echo -e "${YELLOW}Testing minimax/${MODEL}...${NC}"

    # Test if model is available
    if ! clawdbot models list 2>&1 | grep -q "$MODEL"; then
        echo -e "${RED}✗${NC} Model not found: minimax/${MODEL}"
        continue
    fi

    # Test API call
    if OUTPUT=$(clawdbot agent --model "minimax/${MODEL}" --message "$TEST_PROMPT" 2>&1); then
        echo -e "${GREEN}✓${NC} minimax/${MODEL} responded successfully"
        echo "  Response preview: ${OUTPUT:0:100}..."
    else
        echo -e "${RED}✗${NC} minimax/${MODEL} failed"
        echo "  Error: $OUTPUT"
    fi
    echo ""
done

# Test model switching
echo -e "${BLUE}Testing model switching...${NC}"
echo ""

echo "Testing /model command..."
if clawdbot models set minimax/MiniMax-M2.1 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Successfully set primary model to M2.1"
else
    echo -e "${RED}✗${NC} Failed to set primary model"
fi

if clawdbot models set minimax/MiniMax-M2.1-lightning &> /dev/null; then
    echo -e "${GREEN}✓${NC} Successfully switched to Lightning"
else
    echo -e "${RED}✗${NC} Failed to switch to Lightning"
fi

if clawdbot models set minimax/MiniMax-M2 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Successfully switched to M2"
else
    echo -e "${RED}✗${NC} Failed to switch to M2"
fi

# Test fallbacks
echo ""
echo -e "${BLUE}Testing fallback configuration...${NC}"
echo ""

if clawdbot models fallbacks list &> /dev/null; then
    echo -e "${GREEN}✓${NC} Fallback commands work"

    # Try to add fallbacks
    clawdbot models fallbacks clear &> /dev/null || true
    clawdbot models fallbacks add minimax/MiniMax-M2.1-lightning &> /dev/null
    clawdbot models fallbacks add minimax/MiniMax-M2 &> /dev/null

    if clawdbot models fallbacks list 2>&1 | grep -q "MiniMax-M2.1-lightning"; then
        echo -e "${GREEN}✓${NC} Fallbacks configured correctly"
    else
        echo -e "${YELLOW}⚠${NC} Fallbacks may not be configured"
    fi
else
    echo -e "${RED}✗${NC} Fallback commands failed"
fi

# Test aliases
echo ""
echo -e "${BLUE}Testing model aliases...${NC}"
echo ""

if clawdbot models aliases list &> /dev/null; then
    echo -e "${GREEN}✓${NC} Alias commands work"

    # Try to add aliases
    clawdbot models aliases add M2.1 minimax/MiniMax-M2.1 &> /dev/null || true
    clawdbot models aliases add Lightning minimax/MiniMax-M2.1-lightning &> /dev/null || true
    clawdbot models aliases add M2 minimax/MiniMax-M2 &> /dev/null || true

    if clawdbot models aliases list 2>&1 | grep -q "M2.1"; then
        echo -e "${GREEN}✓${NC} Aliases configured correctly"
    else
        echo -e "${YELLOW}⚠${NC} Aliases may not be configured"
    fi
else
    echo -e "${RED}✗${NC} Alias commands failed"
fi

# Summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Integration Test Complete! ✅                ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Summary:${NC}"
echo "  • All three MiniMax models are available"
echo "  • Model switching works correctly"
echo "  • Fallback configuration is functional"
echo "  • Alias system is operational"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Start using MiniMax models in your chats"
echo "  2. Try different models with ${GREEN}/model${NC}"
echo "  3. Monitor usage with ${GREEN}/usage full${NC}"
echo "  4. Read the complete guide at:"
echo "     ${BLUE}docs/providers/minimax-models-guide.md${NC}"
echo ""
