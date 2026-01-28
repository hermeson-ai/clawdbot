# Pull Request: 扩展 MiniMax 三模型支持

## 📝 概述

为 Clawdbot 添加完整的 MiniMax 模型支持，包括 M2.1、M2.1-lightning 和 M2 三个模型。基于 [MiniMax Anthropic API 文档](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)实现。

## 🎯 目标

- ✅ 支持 MiniMax 的三个模型变体
- ✅ 提供灵活的配置方案
- ✅ 完善的文档和示例
- ✅ 自动化设置工具
- ✅ 完整的测试覆盖

## 🔧 技术变更

### 1. 核心代码

#### `src/commands/onboard-auth.models.ts`
```typescript
// 扩展模型目录
const MINIMAX_MODEL_CATALOG = {
  "MiniMax-M2.1": { ... },
  "MiniMax-M2.1-lightning": { ... },
  "MiniMax-M2": { ... },  // 新增
}

// 新增辅助函数
export function buildAllMinimaxApiModels(): ModelDefinitionConfig[]
```

**变更说明:**
- 添加 M2 模型到 catalog
- 为每个模型添加 contextWindow 和 maxTokens
- 新增批量构建函数
- 改进 catalog 查询逻辑

### 2. 文档

#### 新增文件
- `docs/providers/minimax-models-guide.md` - 完整使用指南
- `docs/examples/minimax-full-config.json5` - 配置模板
- `docs/providers/minimax-quickstart-zh.md` - 中文快速入门

#### 修改文件
- `docs/providers/minimax.md` - 更新模型信息
- `docs/providers/index.md` - 添加新文档链接

### 3. 工具脚本

#### 新增脚本
- `scripts/setup-minimax.sh` - 交互式配置脚本
- `scripts/test-minimax-integration.sh` - 集成测试脚本

**功能:**
- 自动配置验证
- 4 种配置模式
- 彩色终端输出
- 配置备份
- API Key 验证

## 📚 文档结构

```
docs/
├── providers/
│   ├── minimax.md                    # 核心文档（更新）
│   ├── minimax-models-guide.md       # 完整指南（新增）
│   ├── minimax-quickstart-zh.md      # 中文快速入门（新增）
│   └── index.md                      # 索引（更新）
└── examples/
    └── minimax-full-config.json5     # 配置模板（新增）

scripts/
├── setup-minimax.sh                  # 设置脚本（新增）
└── test-minimax-integration.sh       # 测试脚本（新增）

MINIMAX_EXTENSION_SUMMARY.md          # 总结文档（新增）
```

## 🚀 使用方式

### 快速开始
```bash
# 方式 1: 自动化脚本
./scripts/setup-minimax.sh

# 方式 2: 手动配置
export MINIMAX_API_KEY="sk-..."
clawdbot configure
# 选择: Model/auth → MiniMax M2.1

# 方式 3: 复制配置模板
cp docs/examples/minimax-full-config.json5 ~/.clawdbot/clawdbot.json
```

### 模型切换
```bash
# CLI
clawdbot models set minimax/MiniMax-M2.1
clawdbot models set minimax/MiniMax-M2.1-lightning
clawdbot models set minimax/MiniMax-M2

# 聊天中
/model M2.1
/model Lightning
/model M2
```

## 📊 配置方案

提供 4 种预设配置：

1. **全模型配置** (推荐) - 所有三个模型 + 智能回退
2. **单模型配置** - 仅 M2.1，最简单
3. **速度优先配置** - Lightning 主力
4. **混合配置** - Claude + MiniMax 混合

## 🧪 测试

### 运行测试
```bash
# 集成测试
./scripts/test-minimax-integration.sh

# 手动测试
clawdbot agent --model minimax/MiniMax-M2.1 --message "测试"
clawdbot agent --model minimax/MiniMax-M2.1-lightning --message "测试"
clawdbot agent --model minimax/MiniMax-M2 --message "测试"
```

### 测试覆盖
- ✅ 三个模型的 API 调用
- ✅ 模型切换功能
- ✅ 回退配置
- ✅ 别名系统
- ✅ 配置验证

## 🎯 模型对比

| Feature | M2.1 | M2.1-lightning | M2 |
|---------|------|----------------|-----|
| 发布时间 | 2025.12 | 2025.12 | 2024 |
| 速度 | 标准 | 快速 | 标准 |
| 质量 | 最高 | 高 | 高 |
| 编程能力 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 工具调用 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 上下文 | 200K | 200K | 200K |
| 最大输出 | 8192 | 8192 | 8192 |

## 💡 设计决策

### 为什么添加 M2？
- 提供稳定的回退选项
- 可能有更低的成本
- 满足用户选择多样性

### 为什么使用 Anthropic API 格式？
- MiniMax 官方推荐
- 与 Claude 兼容性好
- 支持完整的功能集

### 为什么提供多种配置方案？
- 不同用户有不同需求
- 速度 vs 质量的权衡
- 成本优化考虑

## 📝 Breaking Changes

无破坏性变更。这是向后兼容的增量更新。

## 🔄 迁移指南

现有用户无需迁移。新功能是可选的：

```bash
# 继续使用现有配置
clawdbot gateway run

# 或升级到多模型配置
./scripts/setup-minimax.sh
```

## ✅ 验收标准

- [x] 所有三个模型在代码中定义
- [x] 配置模板包含所有模型
- [x] 文档覆盖所有使用场景
- [x] 提供自动化设置工具
- [x] 提供集成测试脚本
- [x] CLI 命令支持三个模型
- [x] 中英文文档齐全
- [x] 故障排除文档完整

## 🐛 已知问题

无已知问题。

## 📖 相关文档

- [MiniMax API 文档](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)
- [Clawdbot 模型文档](https://docs.clawd.bot/concepts/models)
- [模型供应商指南](https://docs.clawd.bot/concepts/model-providers)

## 👥 贡献者

- [@你的GitHub用户名] - 初始实现

## 📅 时间线

- 2025-01-XX: 需求分析和设计
- 2025-01-XX: 核心代码实现
- 2025-01-XX: 文档编写
- 2025-01-XX: 工具脚本开发
- 2025-01-XX: 测试和验证

## 🎉 总结

此 PR 为 Clawdbot 添加了完整的 MiniMax 三模型支持，包括：

- 🔧 **核心功能**: 三个模型的完整集成
- 📚 **完善文档**: 中英文使用指南
- 🛠️ **自动化工具**: 一键配置脚本
- 🧪 **测试覆盖**: 集成测试脚本
- 💼 **用户友好**: 多种配置方案

用户现在可以灵活选择和切换 MiniMax 的三个模型，根据需求优化速度、质量和成本。

---

## 审查清单

请审查者关注：

- [ ] 代码风格是否符合项目规范
- [ ] TypeScript 类型定义是否正确
- [ ] 文档是否清晰完整
- [ ] 配置示例是否可用
- [ ] 脚本是否安全可靠
- [ ] 是否有遗漏的边界情况

## 测试说明

审查者可以这样测试：

```bash
# 1. 运行设置脚本
./scripts/setup-minimax.sh

# 2. 运行集成测试
export MINIMAX_API_KEY="sk-your-test-key"
./scripts/test-minimax-integration.sh

# 3. 手动测试三个模型
clawdbot agent --model minimax/MiniMax-M2.1 --message "测试"
clawdbot agent --model minimax/MiniMax-M2.1-lightning --message "测试"
clawdbot agent --model minimax/MiniMax-M2 --message "测试"
```

感谢审查！🙏
