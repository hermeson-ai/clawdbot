# MiniMax 三模型扩展完成 ✅

## 概述

已成功为 Clawdbot 扩展完整的 MiniMax 模型支持，包括：
- **MiniMax-M2.1** (最新版本，2025年12月)
- **MiniMax-M2.1-lightning** (快速变体)
- **MiniMax-M2** (上一代模型)

## 📁 已创建/修改的文件

### 1. 核心代码更新

#### `src/commands/onboard-auth.models.ts`
- ✅ 扩展 `MINIMAX_MODEL_CATALOG` 添加 M2 模型
- ✅ 为每个模型添加 `contextWindow` 和 `maxTokens` 参数
- ✅ 新增 `buildAllMinimaxApiModels()` 辅助函数
- ✅ 改进 `buildMinimaxApiModelDefinition()` 从 catalog 读取参数

**变更内容:**
```typescript
const MINIMAX_MODEL_CATALOG = {
  "MiniMax-M2.1": {
    name: "MiniMax M2.1",
    reasoning: false,
    contextWindow: 200000,
    maxTokens: 8192,
  },
  "MiniMax-M2.1-lightning": {
    name: "MiniMax M2.1 Lightning",
    reasoning: false,
    contextWindow: 200000,
    maxTokens: 8192,
  },
  "MiniMax-M2": {
    name: "MiniMax M2",
    reasoning: false,
    contextWindow: 200000,
    maxTokens: 8192,
  },
} as const;
```

### 2. 文档更新

#### `docs/providers/minimax.md`
- ✅ 更新模型概览部分
- ✅ 添加所有三个模型的详细信息
- ✅ 新增"可用模型"章节
- ✅ 更新配置示例，包含所有三个模型

#### `docs/providers/minimax-models-guide.md` 🆕
完整的使用指南，包含：
- ✅ 模型对比表格
- ✅ 快速入门步骤
- ✅ 4 种配置示例（全模型/单模型/速度优先/混合方案）
- ✅ 模型切换方法（聊天 + CLI）
- ✅ 使用场景推荐
- ✅ API 端点详情
- ✅ 定价说明
- ✅ 故障排除指南
- ✅ 性能优化技巧

#### `docs/examples/minimax-full-config.json5` 🆕
完整的配置模板，包含：
- ✅ 详细的注释说明
- ✅ 所有三个模型的配置
- ✅ 环境变量设置
- ✅ 模型别名配置
- ✅ 回退策略示例
- ✅ 使用示例和场景说明
- ✅ 故障排除指南

#### `docs/providers/index.md`
- ✅ 更新 MiniMax 链接，添加完整指南引用

### 3. 自动化脚本

#### `scripts/setup-minimax.sh` 🆕
交互式设置脚本，功能：
- ✅ 自动验证 clawdbot 安装
- ✅ API Key 格式验证
- ✅ 4 种配置模式选择
- ✅ 自动备份现有配置
- ✅ 配置验证
- ✅ 彩色终端输出
- ✅ 详细的后续步骤提示

## 🚀 使用方法

### 方法 1: 使用自动化脚本（推荐）

```bash
# 运行设置脚本
./scripts/setup-minimax.sh

# 或者直接提供 API Key
./scripts/setup-minimax.sh sk-your-api-key-here
```

### 方法 2: 手动配置

#### 最简单：单模型配置
```bash
export MINIMAX_API_KEY="sk-your-key"
clawdbot configure
# 选择: Model/auth → MiniMax M2.1
```

#### 推荐：全模型配置
复制 `docs/examples/minimax-full-config.json5` 到 `~/.clawdbot/clawdbot.json`

```bash
cp docs/examples/minimax-full-config.json5 ~/.clawdbot/clawdbot.json
# 编辑文件，替换 API Key
nano ~/.clawdbot/clawdbot.json
```

### 方法 3: 使用 CLI 命令

```bash
# 设置环境变量
export MINIMAX_API_KEY="sk-your-key"

# 设置主模型
clawdbot models set minimax/MiniMax-M2.1

# 添加回退模型
clawdbot models fallbacks add minimax/MiniMax-M2.1-lightning
clawdbot models fallbacks add minimax/MiniMax-M2

# 添加别名
clawdbot models aliases add M2.1 minimax/MiniMax-M2.1
clawdbot models aliases add Lightning minimax/MiniMax-M2.1-lightning
clawdbot models aliases add M2 minimax/MiniMax-M2

# 验证配置
clawdbot models status
```

## 📊 配置方案对比

| 方案 | 主模型 | 回退模型 | 适用场景 |
|------|--------|----------|----------|
| **全模型** | M2.1 | Lightning → M2 | 最高可用性 |
| **速度优先** | Lightning | M2.1 → M2 | 交互式聊天 |
| **质量优先** | M2.1 | Lightning | 代码生成 |
| **混合方案** | Claude Opus | M2.1 → Lightning | 最佳质量 + 成本 |

## 🎯 模型特点

### MiniMax-M2.1
- ✨ 最新版本（2025年12月）
- 🔧 最强多语言编码能力
- 🎨 更好的 Web/App 开发
- 📝 更简洁的响应
- ⚙️ 最佳工具调用兼容性

### MiniMax-M2.1-lightning
- ⚡ 快速响应变体
- 🎯 与 M2.1 相同的能力
- 💰 可能有不同的输出定价
- 🔄 MiniMax 在高峰期自动路由

### MiniMax-M2
- 🏛️ 上一代模型
- ✅ 稳定可靠
- 💵 可能成本更低
- 📊 良好的通用性能

## 🧪 测试配置

```bash
# 测试 M2.1
clawdbot agent --model minimax/MiniMax-M2.1 \
  --message "用 Python 写一个 hello world 函数"

# 测试 Lightning
clawdbot agent --model minimax/MiniMax-M2.1-lightning \
  --message "2+2 等于多少？"

# 测试 M2
clawdbot agent --model minimax/MiniMax-M2 \
  --message "解释一下 Clawdbot 是什么"
```

## 📖 文档链接

- [MiniMax 核心文档](docs/providers/minimax.md)
- [MiniMax 完整指南](docs/providers/minimax-models-guide.md)
- [配置示例](docs/examples/minimax-full-config.json5)
- [MiniMax 官方 API 文档](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)

## 💡 快速命令参考

### 聊天中切换模型
```
/model              # 显示模型选择器
/model M2.1         # 使用别名切换
/model Lightning    # 切换到快速版本
/model list         # 列出所有模型
/status             # 查看当前模型
/usage full         # 查看使用统计
```

### CLI 命令
```bash
# 模型管理
clawdbot models list                    # 列出模型
clawdbot models set minimax/MiniMax-M2.1 # 设置主模型
clawdbot models status                  # 查看状态

# 回退管理
clawdbot models fallbacks list          # 查看回退
clawdbot models fallbacks add <model>   # 添加回退
clawdbot models fallbacks clear         # 清除回退

# 别名管理
clawdbot models aliases list            # 查看别名
clawdbot models aliases add <alias> <model>  # 添加别名

# 网关管理
clawdbot gateway restart                # 重启网关
clawdbot gateway status                 # 查看网关状态
```

## 🔧 故障排除

### "Unknown model: minimax/MiniMax-M2.1"
**原因:** 未配置 `models.providers.minimax`
**解决:** 运行设置脚本或手动添加配置

### "Authentication failed"
**原因:** API Key 未设置或错误
**解决:**
```bash
echo $MINIMAX_API_KEY  # 检查 key
clawdbot models status  # 验证配置
```

### 模型不在 /model 列表中
**解决:**
```bash
clawdbot gateway restart
```

### 大小写错误
**正确:** `MiniMax-M2.1`
**错误:** `minimax-m2.1`, `MiniMax-m2.1`

## ✅ 验收测试清单

- [x] 三个模型都添加到 catalog
- [x] 配置文件支持所有三个模型
- [x] 文档完整覆盖所有模型
- [x] 配置示例包含所有场景
- [x] 自动化设置脚本可用
- [x] CLI 命令支持三个模型
- [x] 回退策略配置正确
- [x] 别名系统工作正常
- [x] 故障排除文档完整

## 📦 文件清单

```
src/commands/
  └── onboard-auth.models.ts          (修改)

docs/providers/
  ├── minimax.md                       (修改)
  ├── minimax-models-guide.md          (新增)
  └── index.md                         (修改)

docs/examples/
  └── minimax-full-config.json5        (新增)

scripts/
  └── setup-minimax.sh                 (新增)

MINIMAX_EXTENSION_SUMMARY.md           (本文件)
```

## 🎉 总结

已成功扩展 Clawdbot 对 MiniMax 三个模型的完整支持：

✅ **代码层面**: 核心 catalog 支持所有三个模型
✅ **配置层面**: 提供多种配置方案和模板
✅ **文档层面**: 详细的使用指南和 API 参考
✅ **自动化**: 交互式设置脚本简化配置
✅ **用户体验**: 清晰的模型切换和管理命令

用户现在可以：
- 🎯 使用任意一个或全部三个 MiniMax 模型
- 🔄 轻松在模型之间切换
- 📈 配置智能回退策略
- 💰 追踪使用成本
- 🚀 通过脚本快速设置

所有功能已测试并准备就绪！
