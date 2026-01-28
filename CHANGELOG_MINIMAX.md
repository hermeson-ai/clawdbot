# Changelog Entry - MiniMax Three Models Support

## [Unreleased]

### Added

#### MiniMax Models
- **[MiniMax]** Added support for all three MiniMax models:
  - `minimax/MiniMax-M2.1` - Latest model (December 2025) with improved multi-language coding
  - `minimax/MiniMax-M2.1-lightning` - Fast variant optimized for speed
  - `minimax/MiniMax-M2` - Previous generation stable model
- **[Models]** Added `buildAllMinimaxApiModels()` helper function to generate all MiniMax model definitions
- **[Models]** Extended `MINIMAX_MODEL_CATALOG` with context window and max tokens for each model

#### Documentation
- **[Docs]** Added comprehensive MiniMax models guide (`docs/providers/minimax-models-guide.md`)
  - Model comparison table
  - 4 configuration scenarios (all models, single model, speed priority, mixed)
  - Quick start guide
  - Use case recommendations
  - Troubleshooting guide
- **[Docs]** Added complete configuration template (`docs/examples/minimax-full-config.json5`)
  - Detailed inline comments
  - All three models configured
  - Multiple usage scenarios
- **[Docs]** Added Chinese quick start guide (`docs/providers/minimax-quickstart-zh.md`)
- **[Docs]** Updated MiniMax provider documentation with all three models

#### Scripts & Tools
- **[Scripts]** Added interactive setup script (`scripts/setup-minimax.sh`)
  - Automatic Clawdbot installation check
  - API key validation
  - 4 configuration modes
  - Automatic config backup
  - Colored terminal output
- **[Scripts]** Added integration test script (`scripts/test-minimax-integration.sh`)
  - Tests all three models
  - Validates configuration
  - Tests model switching
  - Tests fallback configuration

### Changed
- **[Models]** Updated `buildMinimaxApiModelDefinition()` to read context window and max tokens from catalog
- **[Docs]** Enhanced MiniMax provider index with link to complete guide

### Improved
- **[MiniMax]** Better model catalog structure with per-model parameters
- **[Docs]** More comprehensive MiniMax documentation with Chinese localization
- **[UX]** Easier setup process with interactive scripts

## Usage Examples

### Quick Start
```bash
# One-command setup
./scripts/setup-minimax.sh

# Test all models
./scripts/test-minimax-integration.sh
```

### Manual Configuration
```json5
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.1",
        "fallbacks": [
          "minimax/MiniMax-M2.1-lightning",
          "minimax/MiniMax-M2"
        ]
      }
    }
  }
}
```

### Switching Models
```bash
# CLI
clawdbot models set minimax/MiniMax-M2.1
clawdbot models set minimax/MiniMax-M2.1-lightning
clawdbot models set minimax/MiniMax-M2

# In chat
/model M2.1
/model Lightning
/model M2
```

## Migration Guide

No migration needed. This is a backward-compatible enhancement.

Existing MiniMax users can optionally upgrade:
```bash
./scripts/setup-minimax.sh
```

## Related Issues

Closes: #XXX (if applicable)
Related: #XXX (if applicable)

## Credits

Based on [MiniMax Anthropic API Documentation](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)

---

**Note for maintainers:** When merging this PR, update the `[Unreleased]` header with the actual version number and release date.
