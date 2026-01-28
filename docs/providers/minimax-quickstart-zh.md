# MiniMax 快速入门指南 🚀

## 一分钟快速开始

### 1. 获取 API Key
访问 [MiniMax 平台](https://platform.minimax.io) → 注册/登录 → API Keys → 创建新 Key

### 2. 一键配置（推荐）
```bash
# 运行自动配置脚本
./scripts/setup-minimax.sh

# 按提示输入 API Key 即可
```

### 3. 开始使用
```bash
# 启动网关
clawdbot gateway run

# 测试对话
clawdbot agent --message "你好，MiniMax！"
```

## 三个模型说明

| 模型 | 特点 | 适用场景 |
|------|------|----------|
| **M2.1** | 🏆 最新最强 | 复杂编程、推理任务 |
| **M2.1-lightning** | ⚡ 快速响应 | 聊天、快速查询 |
| **M2** | 🛡️ 稳定可靠 | 通用任务、成本优化 |

## 切换模型

### 在聊天中
```
/model           # 打开选择器
/model M2.1      # 切换到 M2.1
/model Lightning # 切换到 Lightning
```

### 命令行
```bash
clawdbot models set minimax/MiniMax-M2.1
```

## 常用命令

```bash
# 查看当前配置
clawdbot models status

# 列出所有模型
clawdbot models list

# 重启网关
clawdbot gateway restart

# 查看使用情况
/usage full  # (在聊天中)
```

## 推荐配置

### 方案 1: 全能配置（推荐新手）
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
**优点**: 自动回退，高可用性

### 方案 2: 速度优先
```json5
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.1-lightning"
      }
    }
  }
}
```
**优点**: 响应快，适合聊天

### 方案 3: 混合使用
```json5
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-5",
        "fallbacks": ["minimax/MiniMax-M2.1"]
      }
    }
  }
}
```
**优点**: Claude 主力，MiniMax 备用

## 完整配置示例

复制这个到 `~/.clawdbot/clawdbot.json`:

```json5
{
  "env": {
    "MINIMAX_API_KEY": "sk-你的-API-Key"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "minimax/MiniMax-M2.1",
        "fallbacks": [
          "minimax/MiniMax-M2.1-lightning",
          "minimax/MiniMax-M2"
        ]
      },
      "models": {
        "minimax/MiniMax-M2.1": { "alias": "M2.1" },
        "minimax/MiniMax-M2.1-lightning": { "alias": "闪电" },
        "minimax/MiniMax-M2": { "alias": "M2" }
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "minimax": {
        "baseUrl": "https://api.minimaxi.com/anthropic",
        "apiKey": "${MINIMAX_API_KEY}",
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
  }
}
```

## 故障排除

### 问题: "Unknown model"
```bash
# 检查配置
clawdbot models list

# 重启网关
clawdbot gateway restart
```

### 问题: "Authentication failed"
```bash
# 验证 API Key
echo $MINIMAX_API_KEY

# 检查状态
clawdbot models status
```

### 问题: 模型名称错误
❌ 错误: `minimax-m2.1`
✅ 正确: `MiniMax-M2.1` (注意大小写)

## 使用技巧

1. **使用别名快速切换**: `/model 闪电` 比输入全名快
2. **设置回退链**: 保证服务高可用
3. **监控使用量**: 用 `/usage full` 追踪成本
4. **Lightning 处理简单任务**: 省钱又快
5. **M2.1 处理复杂编程**: 质量最好

## 性能对比

### 编程任务
- 🥇 M2.1: 多语言编程最强
- 🥈 M2.1-lightning: 快速代码补全
- 🥉 M2: 通用编程任务

### 聊天对话
- 🥇 M2.1-lightning: 响应最快
- 🥈 M2.1: 理解最深
- 🥉 M2: 稳定可靠

### 成本优化
- 🥇 M2: 可能成本最低
- 🥈 M2.1-lightning: 快速完成任务
- 🥉 M2.1: 质量优先

## 下一步

- 📚 查看[完整指南](docs/providers/minimax-models-guide.md)
- 🔧 探索[配置示例](docs/examples/minimax-full-config.json5)
- 💬 加入 [Discord 社区](https://discord.gg/clawd)
- 🌐 访问 [MiniMax 官网](https://platform.minimax.io)

## 需要帮助？

- 文档: [docs.clawd.bot](https://docs.clawd.bot)
- Discord: [discord.gg/clawd](https://discord.gg/clawd)
- GitHub: [github.com/clawdbot/clawdbot](https://github.com/clawdbot/clawdbot)

---

**祝你使用愉快！** 🎉

有问题随时在 Discord 询问社区或查看完整文档。
