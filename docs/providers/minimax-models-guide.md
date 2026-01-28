---
summary: "Complete guide to using all MiniMax models (M2.1, M2.1-lightning, M2)"
read_when:
  - You want to understand differences between MiniMax models
  - You need to switch between MiniMax models
  - You want optimal MiniMax configuration
---

# MiniMax Models Complete Guide

This guide covers all three MiniMax models and how to use them effectively in Clawdbot.

## Model Comparison

| Feature | MiniMax-M2.1 | MiniMax-M2.1-lightning | MiniMax-M2 |
|---------|--------------|------------------------|------------|
| **Release** | Dec 2025 | Dec 2025 | 2024 |
| **Speed** | Standard | Fast | Standard |
| **Quality** | Highest | High | High |
| **Use Case** | Complex tasks | Quick responses | General use |
| **Context** | 200K tokens | 200K tokens | 200K tokens |
| **Max Output** | 8,192 tokens | 8,192 tokens | 8,192 tokens |
| **Coding** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Tool Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

## Quick Start

### 1. Get API Key

Visit [MiniMax Platform](https://platform.minimax.io) and:
1. Sign up / log in
2. Navigate to API Keys
3. Create a new key
4. Copy the key (starts with `sk-`)

### 2. Configure Environment

```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.clawdbot/.env
export MINIMAX_API_KEY="sk-your-actual-key-here"
```

### 3. Choose Configuration

Pick one of the configurations below based on your needs.

## Configuration Examples

### Option 1: All Three Models (Recommended)

Use all models with intelligent fallback:

```json5
{
  env: { MINIMAX_API_KEY: "sk-..." },
  agents: {
    defaults: {
      model: {
        primary: "minimax/MiniMax-M2.1",
        fallbacks: [
          "minimax/MiniMax-M2.1-lightning",
          "minimax/MiniMax-M2"
        ]
      },
      models: {
        "minimax/MiniMax-M2.1": { alias: "M2.1" },
        "minimax/MiniMax-M2.1-lightning": { alias: "Lightning" },
        "minimax/MiniMax-M2": { alias: "M2" }
      }
    }
  },
  models: {
    mode: "merge",
    providers: {
      minimax: {
        baseUrl: "https://api.minimaxi.com/anthropic",
        apiKey: "${MINIMAX_API_KEY}",
        api: "anthropic-messages",
        models: [
          {
            id: "MiniMax-M2.1",
            name: "MiniMax M2.1",
            reasoning: false,
            input: ["text"],
            cost: { input: 15, output: 60, cacheRead: 2, cacheWrite: 10 },
            contextWindow: 200000,
            maxTokens: 8192
          },
          {
            id: "MiniMax-M2.1-lightning",
            name: "MiniMax M2.1 Lightning",
            reasoning: false,
            input: ["text"],
            cost: { input: 15, output: 60, cacheRead: 2, cacheWrite: 10 },
            contextWindow: 200000,
            maxTokens: 8192
          },
          {
            id: "MiniMax-M2",
            name: "MiniMax M2",
            reasoning: false,
            input: ["text"],
            cost: { input: 15, output: 60, cacheRead: 2, cacheWrite: 10 },
            contextWindow: 200000,
            maxTokens: 8192
          }
        ]
      }
    }
  }
}
```

**Benefits:**
- ✅ Automatic failover if one model is unavailable
- ✅ Easy switching with `/model` command
- ✅ Lightning fallback for faster responses during high load
- ✅ M2 as final fallback for stability

### Option 2: Lightning First (Speed Priority)

Prioritize speed, fall back to quality:

```json5
{
  env: { MINIMAX_API_KEY: "sk-..." },
  agents: {
    defaults: {
      model: {
        primary: "minimax/MiniMax-M2.1-lightning",
        fallbacks: [
          "minimax/MiniMax-M2.1",
          "minimax/MiniMax-M2"
        ]
      }
    }
  }
  // ... same providers config as above
}
```

**Use when:**
- You need fast responses
- You're building interactive chat applications
- Response time > quality for your use case

### Option 3: Single Model (Simple)

Just use M2.1:

```json5
{
  env: { MINIMAX_API_KEY: "sk-..." },
  agents: {
    defaults: {
      model: { primary: "minimax/MiniMax-M2.1" },
      models: { "minimax/MiniMax-M2.1": { alias: "Minimax" } }
    }
  },
  models: {
    mode: "merge",
    providers: {
      minimax: {
        baseUrl: "https://api.minimaxi.com/anthropic",
        apiKey: "${MINIMAX_API_KEY}",
        api: "anthropic-messages",
        models: [
          {
            id: "MiniMax-M2.1",
            name: "MiniMax M2.1",
            reasoning: false,
            input: ["text"],
            cost: { input: 15, output: 60, cacheRead: 2, cacheWrite: 10 },
            contextWindow: 200000,
            maxTokens: 8192
          }
        ]
      }
    }
  }
}
```

### Option 4: Mixed with Claude (Best of Both)

Use Claude Opus as primary, MiniMax models as fallback:

```json5
{
  env: {
    ANTHROPIC_API_KEY: "sk-ant-...",
    MINIMAX_API_KEY: "sk-..."
  },
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-opus-4-5",
        fallbacks: [
          "minimax/MiniMax-M2.1",
          "minimax/MiniMax-M2.1-lightning"
        ]
      },
      models: {
        "anthropic/claude-opus-4-5": { alias: "Opus" },
        "minimax/MiniMax-M2.1": { alias: "M2.1" },
        "minimax/MiniMax-M2.1-lightning": { alias: "Lightning" }
      }
    }
  }
  // Include both anthropic and minimax in models.providers
}
```

**Benefits:**
- ✅ Claude quality for most tasks
- ✅ MiniMax cost savings as fallback
- ✅ High availability with multiple providers

## Switching Models

### In Chat

```
/model                    # Show model picker
/model list               # List all models
/model 2                  # Select by number
/model minimax/MiniMax-M2.1-lightning  # Switch to Lightning
/model Lightning          # Use alias
```

### Via CLI

```bash
# Set default model
clawdbot models set minimax/MiniMax-M2.1

# Set fallbacks
clawdbot models fallbacks add minimax/MiniMax-M2.1-lightning
clawdbot models fallbacks add minimax/MiniMax-M2

# List configured models
clawdbot models list

# Check current status
clawdbot models status
```

## Use Case Recommendations

### For Software Development
```json5
model: {
  primary: "minimax/MiniMax-M2.1",
  fallbacks: ["minimax/MiniMax-M2.1-lightning"]
}
```
**Why:** M2.1 has the best multi-language coding support.

### For Interactive Chat
```json5
model: {
  primary: "minimax/MiniMax-M2.1-lightning",
  fallbacks: ["minimax/MiniMax-M2.1"]
}
```
**Why:** Lightning provides faster responses for better UX.

### For Complex Reasoning
```json5
model: {
  primary: "minimax/MiniMax-M2.1",
  fallbacks: ["minimax/MiniMax-M2"]
}
```
**Why:** M2.1 has improved composite instruction handling.

### For Cost Optimization
```json5
model: {
  primary: "minimax/MiniMax-M2",
  fallbacks: ["minimax/MiniMax-M2.1-lightning"]
}
```
**Why:** M2 may have lower costs while maintaining good quality.

## API Endpoint Details

All MiniMax models use the same endpoint:

```
Base URL: https://api.minimaxi.com/anthropic
API Format: Anthropic Messages API
Authentication: Bearer token (API Key)
```

### Supported Features
- ✅ Text input
- ✅ Tool/function calling
- ✅ Streaming responses
- ✅ System prompts
- ✅ Multi-turn conversations
- ✅ Temperature control (0.0-1.0)

### Not Supported
- ❌ Image input
- ❌ Document input
- ❌ `top_k` parameter
- ❌ `stop_sequences` parameter
- ❌ `service_tier` parameter

## Pricing Notes

The pricing values in the configs above are estimates:
```json5
cost: {
  input: 15,      // ¥15 per 1M input tokens
  output: 60,     // ¥60 per 1M output tokens
  cacheRead: 2,   // ¥2 per 1M cache read tokens
  cacheWrite: 10  // ¥10 per 1M cache write tokens
}
```

**Important:**
- Prices are in CNY (¥) per 1 million tokens
- Lightning may have different output pricing
- Check [MiniMax Pricing](https://platform.minimax.io/pricing) for current rates
- Update the `cost` values in your config for accurate tracking

## Troubleshooting

### "Unknown model: minimax/MiniMax-M2.1"

**Solution:** Make sure you have the provider configured in `models.providers.minimax`.

### "Authentication failed"

**Solution:** Check that `MINIMAX_API_KEY` is set correctly:
```bash
echo $MINIMAX_API_KEY  # Should print your key
clawdbot models status  # Should show minimax provider
```

### Model not showing in `/model` list

**Solution:** Restart the gateway:
```bash
clawdbot gateway restart
```

### Case sensitivity error

**Solution:** Use exact model IDs:
- ✅ `MiniMax-M2.1` (correct)
- ❌ `minimax-m2.1` (wrong)
- ❌ `MiniMax-m2.1` (wrong)

## Testing Your Configuration

After configuring, test each model:

```bash
# Test M2.1
clawdbot agent --model minimax/MiniMax-M2.1 --message "Write a hello world function in Python"

# Test Lightning
clawdbot agent --model minimax/MiniMax-M2.1-lightning --message "What is 2+2?"

# Test M2
clawdbot agent --model minimax/MiniMax-M2 --message "Explain what Clawdbot does"
```

## Performance Tips

1. **Use Lightning for simple queries** - It's faster and cheaper for basic tasks
2. **Use M2.1 for complex code** - Better multi-language support
3. **Set up fallbacks** - Ensures high availability
4. **Monitor usage** - Use `/usage full` to track token consumption
5. **Cache prompts** - MiniMax supports prompt caching to reduce costs

## Related Documentation

- [MiniMax API Reference](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)
- [Model Selection Guide](/concepts/models)
- [Model Failover](/concepts/model-failover)
- [Model Providers](/concepts/model-providers)
- [MiniMax Provider Docs](/providers/minimax)

## Need Help?

Join the [Clawdbot Discord](https://discord.gg/clawd) for community support or check the [FAQ](/start/faq).
