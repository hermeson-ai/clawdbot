# ✨ MiniMax 三模型扩展 - 使用指南

> 为 Clawdbot 添加完整的 MiniMax M2.1、M2.1-lightning 和 M2 模型支持

## 🎯 这次更新带来了什么？

### 三个强大的模型
- **MiniMax-M2.1** 🏆 - 最新最强，多语言编程专家
- **MiniMax-M2.1-lightning** ⚡ - 快速响应，高效交互
- **MiniMax-M2** 🛡️ - 稳定可靠，成本优化

### 完整的工具链
- 📝 详细的中英文文档
- 🔧 一键配置脚本
- 🧪 自动化测试工具
- 📦 配置模板和示例

## 🚀 5 分钟快速开始

### 步骤 1: 获取 API Key
访问 https://platform.minimax.io → 注册 → 获取 API Key

### 步骤 2: 一键配置
```bash
./scripts/setup-minimax.sh
```

按照提示操作：
1. 输入 API Key
2. 选择配置模式（推荐选 1）
3. 等待自动配置完成

### 步骤 3: 开始使用
```bash
# 启动网关
clawdbot gateway run

# 发送测试消息
clawdbot agent --message "你好，MiniMax！"

# 在聊天中切换模型
/model           # 打开模型选择器
/model M2.1      # 切换到 M2.1
/model Lightning # 切换到闪电版
```

就是这么简单！🎉

## 📚 文档索引

### 必读文档
- [中文快速入门](docs/providers/minimax-quickstart-zh.md) - 5分钟上手指南
- [完整使用指南](docs/providers/minimax-models-guide.md) - 详细功能说明
- [配置模板](docs/examples/minimax-full-config.json5) - 复制即用

### 核心文档
- [MiniMax 供应商文档](docs/providers/minimax.md) - 官方集成文档
- [扩展总结](MINIMAX_EXTENSION_SUMMARY.md) - 技术实现说明
- [变更日志](CHANGELOG_MINIMAX.md) - 更新内容清单

## 🛠️ 配置方案

### 方案 1: 全能配置（推荐）
适合大多数用户，提供最高可用性。

```bash
./scripts/setup-minimax.sh
# 选择选项 1
```

**特点:**
- ✅ 三个模型全部可用
- ✅ 自动智能回退
- ✅ 高可用性保障

### 方案 2: 速度优先
适合交互式应用，追求响应速度。

```bash
./scripts/setup-minimax.sh
# 选择选项 3
```

**特点:**
- ⚡ Lightning 优先
- 🎯 快速响应
- 💬 聊天体验最佳

### 方案 3: 质量优先
适合复杂编程任务，追求最高质量。

```bash
./scripts/setup-minimax.sh
# 选择选项 2
```

**特点:**
- 🏆 M2.1 单模型
- 📊 最佳代码质量
- 🔧 复杂任务最优

### 方案 4: 混合部署
结合 Claude 和 MiniMax 优势。

```bash
./scripts/setup-minimax.sh
# 选择选项 4
```

**特点:**
- 🎭 Claude 主力
- 💰 MiniMax 回退
- 🌟 质量与成本平衡

## 🧪 验证安装

运行集成测试确保一切正常：

```bash
# 设置 API Key
export MINIMAX_API_KEY="sk-your-key"

# 运行测试
./scripts/test-minimax-integration.sh
```

测试内容：
- ✅ 三个模型可用性
- ✅ 模型切换功能
- ✅ 回退配置正确
- ✅ 别名系统正常

## 💡 使用技巧

### 1. 根据任务选择模型
```bash
# 复杂编程 → M2.1
/model M2.1

# 快速问答 → Lightning
/model Lightning

# 一般任务 → M2
/model M2
```

### 2. 设置智能回退
```json5
{
  "model": {
    "primary": "minimax/MiniMax-M2.1",
    "fallbacks": [
      "minimax/MiniMax-M2.1-lightning",
      "minimax/MiniMax-M2"
    ]
  }
}
```

### 3. 监控使用情况
```bash
# 在聊天中
/usage full

# 或命令行
clawdbot models status
```

### 4. 使用别名快速切换
```bash
# 设置别名
clawdbot models aliases add 快速 minimax/MiniMax-M2.1-lightning
clawdbot models aliases add 质量 minimax/MiniMax-M2.1

# 使用别名
/model 快速
/model 质量
```

## 🎓 学习路径

### 初学者
1. 阅读 [中文快速入门](docs/providers/minimax-quickstart-zh.md)
2. 运行 `./scripts/setup-minimax.sh`
3. 尝试不同模型的切换

### 进阶用户
1. 阅读 [完整使用指南](docs/providers/minimax-models-guide.md)
2. 学习配置回退策略
3. 探索混合部署方案

### 高级用户
1. 研究 [配置模板](docs/examples/minimax-full-config.json5)
2. 自定义模型参数
3. 集成到自动化流程

## 🔧 常见问题

### Q: 如何选择模型？
**A:**
- 编程任务 → M2.1
- 快速查询 → Lightning
- 日常对话 → M2
- 不确定 → 使用全模型配置

### Q: 三个模型有什么区别？
**A:** 查看这个对比表：

| 指标 | M2.1 | Lightning | M2 |
|------|------|-----------|-----|
| 质量 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 速度 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 成本 | 💰💰💰 | 💰💰 | 💰 |

### Q: 可以混用不同厂商的模型吗？
**A:** 当然可以！配置示例：
```json5
{
  "model": {
    "primary": "anthropic/claude-opus-4-5",
    "fallbacks": [
      "minimax/MiniMax-M2.1",
      "openai/gpt-5.2"
    ]
  }
}
```

### Q: 如何追踪成本？
**A:** 使用 `/usage full` 命令查看详细的 token 使用情况和估算成本。

### Q: 遇到问题怎么办？
**A:** 查看故障排除部分：
1. 运行 `clawdbot doctor`
2. 查看日志 `clawdbot logs`
3. 阅读 [完整指南](docs/providers/minimax-models-guide.md) 的故障排除章节
4. 在 Discord 寻求帮助

## 📊 性能建议

### 最佳实践
```json5
{
  // 编程工作流
  "coding": {
    "primary": "minimax/MiniMax-M2.1",
    "fallbacks": ["minimax/MiniMax-M2.1-lightning"]
  },

  // 交互式聊天
  "chat": {
    "primary": "minimax/MiniMax-M2.1-lightning",
    "fallbacks": ["minimax/MiniMax-M2.1"]
  },

  // 成本优化
  "cost-effective": {
    "primary": "minimax/MiniMax-M2",
    "fallbacks": ["minimax/MiniMax-M2.1-lightning"]
  }
}
```

## 🤝 获取帮助

### 资源
- 📖 [完整文档](https://docs.clawd.bot)
- 💬 [Discord 社区](https://discord.gg/clawd)
- 🐛 [GitHub Issues](https://github.com/clawdbot/clawdbot/issues)
- 🌐 [MiniMax 官网](https://platform.minimax.io)

### 反馈
如果您有任何问题、建议或 bug 报告，请：
1. 在 Discord 提问
2. 提交 GitHub Issue
3. 查看现有文档

## 📝 许可证

本扩展遵循 Clawdbot 项目的 MIT 许可证。

---

**祝您使用愉快！** 🚀

如有问题，随时联系社区获取帮助。
