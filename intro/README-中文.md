# 🦞 Clawdbot — 个人 AI 助手

<p align="center">
  <img src="https://raw.githubusercontent.com/clawdbot/clawdbot/main/docs/whatsapp-clawd.jpg" alt="Clawdbot" width="400">
</p>

<p align="center">
  <strong>脱壳！脱壳！</strong>
</p>

<p align="center">
  <a href="https://github.com/clawdbot/clawdbot/actions/workflows/ci.yml?branch=main"><img src="https://img.shields.io/github/actions/workflow/status/clawdbot/clawdbot/ci.yml?branch=main&style=for-the-badge" alt="CI status"></a>
  <a href="https://github.com/clawdbot/clawdbot/releases"><img src="https://img.shields.io/github/v/release/clawdbot/clawdbot?include_prereleases&style=for-the-badge" alt="GitHub release"></a>
  <a href="https://deepwiki.com/clawdbot/clawdbot"><img src="https://img.shields.io/badge/DeepWiki-clawdbot-111111?style=for-the-badge" alt="DeepWiki"></a>
  <a href="https://discord.gg/clawd"><img src="https://img.shields.io/discord/1456350064065904867?label=Discord&logo=discord&logoColor=white&color=5865F2&style=for-the-badge" alt="Discord"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

**Clawdbot** 是一个运行在你自己设备上的*个人 AI 助手*。
它可以在你已经使用的各种通讯平台上回复你（WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、WebChat），还支持扩展通道如 BlueBubbles、Matrix、Zalo 和 Zalo Personal。它可以在 macOS/iOS/Android 上进行语音对话，并能渲染一个你可以控制的实时画布。网关只是控制平面——产品本身就是这个助手。

如果你想要一个个人的、单用户的助手，感觉本地化、快速且始终在线，这就是你要找的。

[官网](https://clawdbot.com) · [文档](https://docs.clawd.bot) · [快速开始](https://docs.clawd.bot/start/getting-started) · [更新指南](https://docs.clawd.bot/install/updating) · [展示](https://docs.clawd.bot/start/showcase) · [常见问题](https://docs.clawd.bot/start/faq) · [配置向导](https://docs.clawd.bot/start/wizard) · [Nix](https://github.com/clawdbot/nix-clawdbot) · [Docker](https://docs.clawd.bot/install/docker) · [Discord](https://discord.gg/clawd)

推荐设置：运行配置向导（`clawdbot onboard`）。它会引导你完成网关、工作区、通道和技能的配置。CLI 向导是推荐的路径，适用于 **macOS、Linux 和 Windows（通过 WSL2；强烈推荐）**。
支持 npm、pnpm 或 bun。
新安装？从这里开始：[快速开始](https://docs.clawd.bot/start/getting-started)

**订阅服务（OAuth）：**
- **[Anthropic](https://www.anthropic.com/)**（Claude Pro/Max）
- **[OpenAI](https://openai.com/)**（ChatGPT/Codex）

模型说明：虽然支持任何模型，但我强烈推荐 **Anthropic Pro/Max (100/200) + Opus 4.5**，因为它具有长上下文能力和更好的提示注入抗性。参见[配置指南](https://docs.clawd.bot/start/onboarding)。

## 模型（选择和认证）

- 模型配置 + CLI：[模型](https://docs.clawd.bot/concepts/models)
- 认证配置文件轮换（OAuth vs API 密钥）+ 故障转移：[模型故障转移](https://docs.clawd.bot/concepts/model-failover)

## 安装（推荐）

运行环境：**Node ≥22**。

```bash
npm install -g clawdbot@latest
# 或者：pnpm add -g clawdbot@latest

clawdbot onboard --install-daemon
```

向导会安装网关守护进程（launchd/systemd 用户服务），使其保持运行。

## 快速开始（TL;DR）

运行环境：**Node ≥22**。

完整的初学者指南（认证、配对、通道）：[快速开始](https://docs.clawd.bot/start/getting-started)

```bash
clawdbot onboard --install-daemon

clawdbot gateway --port 18789 --verbose

# 发送消息
clawdbot message send --to +1234567890 --message "Hello from Clawdbot"

# 与助手对话（可选择回复到任何连接的通道：WhatsApp/Telegram/Slack/Discord/Google Chat/Signal/iMessage/BlueBubbles/Microsoft Teams/Matrix/Zalo/Zalo Personal/WebChat）
clawdbot agent --message "Ship checklist" --thinking high
```

升级？[更新指南](https://docs.clawd.bot/install/updating)（并运行 `clawdbot doctor`）。

## 开发通道

- **stable**：标记发布（`vYYYY.M.D` 或 `vYYYY.M.D-<patch>`），npm dist-tag `latest`。
- **beta**：预发布标签（`vYYYY.M.D-beta.N`），npm dist-tag `beta`（可能缺少 macOS 应用）。
- **dev**：`main` 分支的移动头部，npm dist-tag `dev`（发布时）。

切换通道（git + npm）：`clawdbot update --channel stable|beta|dev`。
详情：[开发通道](https://docs.clawd.bot/install/development-channels)。

## 从源码构建（开发）

推荐使用 `pnpm` 进行源码构建。Bun 是可选的，用于直接运行 TypeScript。

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot

pnpm install
pnpm ui:build # 首次运行时自动安装 UI 依赖
pnpm build

pnpm clawdbot onboard --install-daemon

# 开发循环（TS 更改时自动重载）
pnpm gateway:watch
```

注意：`pnpm clawdbot ...` 直接运行 TypeScript（通过 `tsx`）。`pnpm build` 生成 `dist/` 用于通过 Node / 打包的 `clawdbot` 二进制文件运行。

## 安全默认设置（DM 访问）

Clawdbot 连接到真实的消息平台。将入站 DM 视为**不受信任的输入**。

完整安全指南：[安全](https://docs.clawd.bot/gateway/security)

在 Telegram/WhatsApp/Signal/iMessage/Microsoft Teams/Discord/Google Chat/Slack 上的默认行为：
- **DM 配对**（`dmPolicy="pairing"` / `channels.discord.dm.policy="pairing"` / `channels.slack.dm.policy="pairing"`）：未知发送者会收到一个短配对码，机器人不会处理他们的消息。
- 批准方式：`clawdbot pairing approve <channel> <code>`（然后发送者被添加到本地允许列表存储）。
- 公开入站 DM 需要明确选择加入：设置 `dmPolicy="open"` 并在通道允许列表中包含 `"*"`（`allowFrom` / `channels.discord.dm.allowFrom` / `channels.slack.dm.allowFrom`）。

运行 `clawdbot doctor` 来发现有风险/配置错误的 DM 策略。

## 亮点

- **[本地优先网关](https://docs.clawd.bot/gateway)** — 会话、通道、工具和事件的单一控制平面。
- **[多通道收件箱](https://docs.clawd.bot/channels)** — WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、BlueBubbles、Microsoft Teams、Matrix、Zalo、Zalo Personal、WebChat、macOS、iOS/Android。
- **[多代理路由](https://docs.clawd.bot/gateway/configuration)** — 将入站通道/账户/对等方路由到隔离的代理（工作区 + 每个代理的会话）。
- **[语音唤醒](https://docs.clawd.bot/nodes/voicewake) + [对话模式](https://docs.clawd.bot/nodes/talk)** — macOS/iOS/Android 上的始终在线语音，支持 ElevenLabs。
- **[实时画布](https://docs.clawd.bot/platforms/mac/canvas)** — 代理驱动的可视化工作区，支持 [A2UI](https://docs.clawd.bot/platforms/mac/canvas#canvas-a2ui)。
- **[一流工具](https://docs.clawd.bot/tools)** — 浏览器、画布、节点、定时任务、会话和 Discord/Slack 操作。
- **[伴侣应用](https://docs.clawd.bot/platforms/macos)** — macOS 菜单栏应用 + iOS/Android [节点](https://docs.clawd.bot/nodes)。
- **[配置向导](https://docs.clawd.bot/start/wizard) + [技能](https://docs.clawd.bot/tools/skills)** — 向导驱动的设置，包含捆绑/管理/工作区技能。

## 星标历史

[![Star History Chart](https://api.star-history.com/svg?repos=clawdbot/clawdbot&type=date&legend=top-left)](https://www.star-history.com/#clawdbot/clawdbot&type=date&legend=top-left)

## 我们迄今为止构建的一切

### 核心平台
- [网关 WS 控制平面](https://docs.clawd.bot/gateway)，包含会话、存在、配置、定时任务、Webhook、[控制 UI](https://docs.clawd.bot/web) 和[画布主机](https://docs.clawd.bot/platforms/mac/canvas#canvas-a2ui)。
- [CLI 界面](https://docs.clawd.bot/tools/agent-send)：网关、代理、发送、[向导](https://docs.clawd.bot/start/wizard) 和[诊断](https://docs.clawd.bot/gateway/doctor)。
- [Pi 代理运行时](https://docs.clawd.bot/concepts/agent)，RPC 模式，支持工具流和块流。
- [会话模型](https://docs.clawd.bot/concepts/session)：直接聊天的 `main`、群组隔离、激活模式、队列模式、回复。群组规则：[群组](https://docs.clawd.bot/concepts/groups)。
- [媒体管道](https://docs.clawd.bot/nodes/images)：图像/音频/视频、转录钩子、大小限制、临时文件生命周期。音频详情：[音频](https://docs.clawd.bot/nodes/audio)。

### 通道
- [通道](https://docs.clawd.bot/channels)：[WhatsApp](https://docs.clawd.bot/channels/whatsapp)（Baileys）、[Telegram](https://docs.clawd.bot/channels/telegram)（grammY）、[Slack](https://docs.clawd.bot/channels/slack)（Bolt）、[Discord](https://docs.clawd.bot/channels/discord)（discord.js）、[Google Chat](https://docs.clawd.bot/channels/googlechat)（Chat API）、[Signal](https://docs.clawd.bot/channels/signal)（signal-cli）、[iMessage](https://docs.clawd.bot/channels/imessage)（imsg）、[BlueBubbles](https://docs.clawd.bot/channels/bluebubbles)（扩展）、[Microsoft Teams](https://docs.clawd.bot/channels/msteams)（扩展）、[Matrix](https://docs.clawd.bot/channels/matrix)（扩展）、[Zalo](https://docs.clawd.bot/channels/zalo)（扩展）、[Zalo Personal](https://docs.clawd.bot/channels/zalouser)（扩展）、[WebChat](https://docs.clawd.bot/web/webchat)。
- [群组路由](https://docs.clawd.bot/concepts/group-messages)：提及门控、回复标签、每通道分块和路由。通道规则：[通道](https://docs.clawd.bot/channels)。

### 应用 + 节点
- [macOS 应用](https://docs.clawd.bot/platforms/macos)：菜单栏控制平面、[语音唤醒](https://docs.clawd.bot/nodes/voicewake)/PTT、[对话模式](https://docs.clawd.bot/nodes/talk)覆盖、[WebChat](https://docs.clawd.bot/web/webchat)、调试工具、[远程网关](https://docs.clawd.bot/gateway/remote)控制。
- [iOS 节点](https://docs.clawd.bot/platforms/ios)：[画布](https://docs.clawd.bot/platforms/mac/canvas)、[语音唤醒](https://docs.clawd.bot/nodes/voicewake)、[对话模式](https://docs.clawd.bot/nodes/talk)、相机、屏幕录制、Bonjour 配对。
- [Android 节点](https://docs.clawd.bot/platforms/android)：[画布](https://docs.clawd.bot/platforms/mac/canvas)、[对话模式](https://docs.clawd.bot/nodes/talk)、相机、屏幕录制、可选 SMS。
- [macOS 节点模式](https://docs.clawd.bot/nodes)：system.run/notify + 画布/相机暴露。

### 工具 + 自动化
- [浏览器控制](https://docs.clawd.bot/tools/browser)：专用的 clawd Chrome/Chromium、快照、操作、上传、配置文件。
- [画布](https://docs.clawd.bot/platforms/mac/canvas)：[A2UI](https://docs.clawd.bot/platforms/mac/canvas#canvas-a2ui) 推送/重置、评估、快照。
- [节点](https://docs.clawd.bot/nodes)：相机拍照/录像、屏幕录制、[location.get](https://docs.clawd.bot/nodes/location-command)、通知。
- [定时任务 + 唤醒](https://docs.clawd.bot/automation/cron-jobs)；[Webhook](https://docs.clawd.bot/automation/webhook)；[Gmail Pub/Sub](https://docs.clawd.bot/automation/gmail-pubsub)。
- [技能平台](https://docs.clawd.bot/tools/skills)：捆绑、管理和工作区技能，支持安装门控 + UI。

### 运行时 + 安全
- [通道路由](https://docs.clawd.bot/concepts/channel-routing)、[重试策略](https://docs.clawd.bot/concepts/retry) 和[流/分块](https://docs.clawd.bot/concepts/streaming)。
- [存在](https://docs.clawd.bot/concepts/presence)、[输入指示器](https://docs.clawd.bot/concepts/typing-indicators) 和[使用跟踪](https://docs.clawd.bot/concepts/usage-tracking)。
- [模型](https://docs.clawd.bot/concepts/models)、[模型故障转移](https://docs.clawd.bot/concepts/model-failover) 和[会话修剪](https://docs.clawd.bot/concepts/session-pruning)。
- [安全](https://docs.clawd.bot/gateway/security) 和[故障排除](https://docs.clawd.bot/channels/troubleshooting)。

### 运维 + 打包
- [控制 UI](https://docs.clawd.bot/web) + [WebChat](https://docs.clawd.bot/web/webchat) 直接从网关提供服务。
- [Tailscale Serve/Funnel](https://docs.clawd.bot/gateway/tailscale) 或[SSH 隧道](https://docs.clawd.bot/gateway/remote)，支持令牌/密码认证。
- [Nix 模式](https://docs.clawd.bot/install/nix)用于声明式配置；基于 [Docker](https://docs.clawd.bot/install/docker) 的安装。
- [诊断](https://docs.clawd.bot/gateway/doctor)迁移、[日志记录](https://docs.clawd.bot/logging)。

## 工作原理（简述）

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / BlueBubbles / Microsoft Teams / Matrix / Zalo / Zalo Personal / WebChat
               │
               ▼
┌───────────────────────────────┐
│            网关               │
│        （控制平面）            │
│     ws://127.0.0.1:18789      │
└──────────────┬────────────────┘
               │
               ├─ Pi 代理（RPC）
               ├─ CLI（clawdbot …）
               ├─ WebChat UI
               ├─ macOS 应用
               └─ iOS / Android 节点
```

## 关键子系统

- **[网关 WebSocket 网络](https://docs.clawd.bot/concepts/architecture)** — 客户端、工具和事件的单一 WS 控制平面（加上运维：[网关运行手册](https://docs.clawd.bot/gateway)）。
- **[Tailscale 暴露](https://docs.clawd.bot/gateway/tailscale)** — 网关仪表板 + WS 的 Serve/Funnel（远程访问：[远程](https://docs.clawd.bot/gateway/remote)）。
- **[浏览器控制](https://docs.clawd.bot/tools/browser)** — clawd 管理的 Chrome/Chromium，支持 CDP 控制。
- **[画布 + A2UI](https://docs.clawd.bot/platforms/mac/canvas)** — 代理驱动的可视化工作区（A2UI 主机：[画布/A2UI](https://docs.clawd.bot/platforms/mac/canvas#canvas-a2ui)）。
- **[语音唤醒](https://docs.clawd.bot/nodes/voicewake) + [对话模式](https://docs.clawd.bot/nodes/talk)** — 始终在线语音和连续对话。
- **[节点](https://docs.clawd.bot/nodes)** — 画布、相机拍照/录像、屏幕录制、`location.get`、通知，加上 macOS 专用的 `system.run`/`system.notify`。

## Tailscale 访问（网关仪表板）

Clawdbot 可以自动配置 Tailscale **Serve**（仅 tailnet）或 **Funnel**（公开），同时网关保持绑定到回环。配置 `gateway.tailscale.mode`：

- `off`：无 Tailscale 自动化（默认）。
- `serve`：通过 `tailscale serve` 仅 tailnet HTTPS（默认使用 Tailscale 身份头）。
- `funnel`：通过 `tailscale funnel` 公开 HTTPS（需要共享密码认证）。

注意：
- 启用 Serve/Funnel 时，`gateway.bind` 必须保持 `loopback`（Clawdbot 强制执行此规则）。
- 通过设置 `gateway.auth.mode: "password"` 或 `gateway.auth.allowTailscale: false` 可以强制 Serve 需要密码。
- 除非设置 `gateway.auth.mode: "password"`，否则 Funnel 拒绝启动。
- 可选：`gateway.tailscale.resetOnExit` 在关闭时撤销 Serve/Funnel。

详情：[Tailscale 指南](https://docs.clawd.bot/gateway/tailscale) · [Web 界面](https://docs.clawd.bot/web)

## 远程网关（Linux 很棒）

在小型 Linux 实例上运行网关是完全可以的。客户端（macOS 应用、CLI、WebChat）可以通过 **Tailscale Serve/Funnel** 或 **SSH 隧道** 连接，你仍然可以配对设备节点（macOS/iOS/Android）在需要时执行设备本地操作。

- **网关主机** 默认运行执行工具和通道连接。
- **设备节点** 通过 `node.invoke` 运行设备本地操作（`system.run`、相机、屏幕录制、通知）。
简而言之：执行在网关所在的地方运行；设备操作在设备所在的地方运行。

详情：[远程访问](https://docs.clawd.bot/gateway/remote) · [节点](https://docs.clawd.bot/nodes) · [安全](https://docs.clawd.bot/gateway/security)

## 通过网关协议的 macOS 权限

macOS 应用可以在**节点模式**下运行，并通过网关 WebSocket 公布其功能 + 权限映射（`node.list` / `node.describe`）。然后客户端可以通过 `node.invoke` 执行本地操作：

- `system.run` 运行本地命令并返回 stdout/stderr/退出码；设置 `needsScreenRecording: true` 需要屏幕录制权限（否则你会得到 `PERMISSION_MISSING`）。
- `system.notify` 发布用户通知，如果通知被拒绝则失败。
- `canvas.*`、`camera.*`、`screen.record` 和 `location.get` 也通过 `node.invoke` 路由，并遵循 TCC 权限状态。

提升的 bash（主机权限）与 macOS TCC 是分开的：

- 使用 `/elevated on|off` 在启用 + 允许列表时切换每会话提升访问。
- 网关通过 `sessions.patch`（WS 方法）持久化每会话切换，与 `thinkingLevel`、`verboseLevel`、`model`、`sendPolicy` 和 `groupActivation` 一起。

详情：[节点](https://docs.clawd.bot/nodes) · [macOS 应用](https://docs.clawd.bot/platforms/macos) · [网关协议](https://docs.clawd.bot/concepts/architecture)

## 代理到代理（sessions_* 工具）

- 使用这些来协调跨会话的工作，而无需在聊天界面之间跳转。
- `sessions_list` — 发现活动会话（代理）及其元数据。
- `sessions_history` — 获取会话的转录日志。
- `sessions_send` — 向另一个会话发送消息；可选回复乒乓 + 公告步骤（`REPLY_SKIP`、`ANNOUNCE_SKIP`）。

详情：[会话工具](https://docs.clawd.bot/concepts/session-tool)

## 技能注册表（ClawdHub）

ClawdHub 是一个最小的技能注册表。启用 ClawdHub 后，代理可以自动搜索技能并根据需要拉取新技能。

[ClawdHub](https://ClawdHub.com)

## 聊天命令

在 WhatsApp/Telegram/Slack/Google Chat/Microsoft Teams/WebChat 中发送这些（群组命令仅限所有者）：

- `/status` — 紧凑的会话状态（模型 + 令牌，可用时显示成本）
- `/new` 或 `/reset` — 重置会话
- `/compact` — 压缩会话上下文（摘要）
- `/think <level>` — off|minimal|low|medium|high|xhigh（仅 GPT-5.2 + Codex 模型）
- `/verbose on|off`
- `/usage off|tokens|full` — 每响应使用页脚
- `/restart` — 重启网关（群组中仅限所有者）
- `/activation mention|always` — 群组激活切换（仅群组）

## 应用（可选）

仅网关就能提供出色的体验。所有应用都是可选的，并添加额外功能。

如果你计划构建/运行伴侣应用，请遵循下面的平台运行手册。

### macOS（Clawdbot.app）（可选）

- 网关和健康状况的菜单栏控制。
- 语音唤醒 + 按键通话覆盖。
- WebChat + 调试工具。
- 通过 SSH 的远程网关控制。

注意：需要签名构建才能使 macOS 权限在重建后保持（参见 `docs/mac/permissions.md`）。

### iOS 节点（可选）

- 通过桥接器作为节点配对。
- 语音触发转发 + 画布界面。
- 通过 `clawdbot nodes …` 控制。

运行手册：[iOS 连接](https://docs.clawd.bot/platforms/ios)。

### Android 节点（可选）

- 通过与 iOS 相同的桥接器 + 配对流程配对。
- 暴露画布、相机和屏幕捕获命令。
- 运行手册：[Android 连接](https://docs.clawd.bot/platforms/android)。

## 代理工作区 + 技能

- 工作区根目录：`~/clawd`（可通过 `agents.defaults.workspace` 配置）。
- 注入的提示文件：`AGENTS.md`、`SOUL.md`、`TOOLS.md`。
- 技能：`~/clawd/skills/<skill>/SKILL.md`。

## 配置

最小 `~/.clawdbot/clawdbot.json`（模型 + 默认值）：

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-5"
  }
}
```

[完整配置参考（所有键 + 示例）。](https://docs.clawd.bot/gateway/configuration)

## 安全模型（重要）

- **默认：** 工具在**主**会话的主机上运行，所以当只有你时，代理具有完全访问权限。
- **群组/通道安全：** 设置 `agents.defaults.sandbox.mode: "non-main"` 在每会话 Docker 沙箱内运行**非主会话**（群组/通道）；然后 bash 在这些会话的 Docker 中运行。
- **沙箱默认值：** 允许列表 `bash`、`process`、`read`、`write`、`edit`、`sessions_list`、`sessions_history`、`sessions_send`、`sessions_spawn`；拒绝列表 `browser`、`canvas`、`nodes`、`cron`、`discord`、`gateway`。

详情：[安全指南](https://docs.clawd.bot/gateway/security) · [Docker + 沙箱](https://docs.clawd.bot/install/docker) · [沙箱配置](https://docs.clawd.bot/gateway/configuration)

### [WhatsApp](https://docs.clawd.bot/channels/whatsapp)

- 链接设备：`pnpm clawdbot channels login`（将凭据存储在 `~/.clawdbot/credentials` 中）。
- 通过 `channels.whatsapp.allowFrom` 允许列表谁可以与助手对话。
- 如果设置了 `channels.whatsapp.groups`，它将成为群组允许列表；包含 `"*"` 以允许所有。

### [Telegram](https://docs.clawd.bot/channels/telegram)

- 设置 `TELEGRAM_BOT_TOKEN` 或 `channels.telegram.botToken`（环境变量优先）。
- 可选：设置 `channels.telegram.groups`（带有 `channels.telegram.groups."*".requireMention`）；设置时，它是群组允许列表（包含 `"*"` 以允许所有）。还有 `channels.telegram.allowFrom` 或 `channels.telegram.webhookUrl`（根据需要）。

```json5
{
  channels: {
    telegram: {
      botToken: "123456:ABCDEF"
    }
  }
}
```

### [Slack](https://docs.clawd.bot/channels/slack)

- 设置 `SLACK_BOT_TOKEN` + `SLACK_APP_TOKEN`（或 `channels.slack.botToken` + `channels.slack.appToken`）。

### [Discord](https://docs.clawd.bot/channels/discord)

- 设置 `DISCORD_BOT_TOKEN` 或 `channels.discord.token`（环境变量优先）。
- 可选：设置 `commands.native`、`commands.text` 或 `commands.useAccessGroups`，加上 `channels.discord.dm.allowFrom`、`channels.discord.guilds` 或 `channels.discord.mediaMaxMb`（根据需要）。

```json5
{
  channels: {
    discord: {
      token: "1234abcd"
    }
  }
}
```

### [Signal](https://docs.clawd.bot/channels/signal)

- 需要 `signal-cli` 和 `channels.signal` 配置部分。

### [iMessage](https://docs.clawd.bot/channels/imessage)

- 仅 macOS；必须登录 Messages。
- 如果设置了 `channels.imessage.groups`，它将成为群组允许列表；包含 `"*"` 以允许所有。

### [Microsoft Teams](https://docs.clawd.bot/channels/msteams)

- 配置 Teams 应用 + Bot Framework，然后添加 `msteams` 配置部分。
- 通过 `msteams.allowFrom` 允许列表谁可以对话；通过 `msteams.groupAllowFrom` 或 `msteams.groupPolicy: "open"` 进行群组访问。

### [WebChat](https://docs.clawd.bot/web/webchat)

- 使用网关 WebSocket；无需单独的 WebChat 端口/配置。

浏览器控制（可选）：

```json5
{
  browser: {
    enabled: true,
    color: "#FF4500"
  }
}
```

## 文档

当你完成配置流程并想要更深入的参考时使用这些。
- [从文档索引开始导航和了解"什么在哪里"。](https://docs.clawd.bot)
- [阅读架构概述了解网关 + 协议模型。](https://docs.clawd.bot/concepts/architecture)
- [当你需要每个键和示例时使用完整配置参考。](https://docs.clawd.bot/gateway/configuration)
- [按照书本运行网关的操作运行手册。](https://docs.clawd.bot/gateway)
- [了解控制 UI/Web 界面的工作原理以及如何安全暴露它们。](https://docs.clawd.bot/web)
- [了解通过 SSH 隧道或 tailnet 的远程访问。](https://docs.clawd.bot/gateway/remote)
- [遵循配置向导流程进行引导式设置。](https://docs.clawd.bot/start/wizard)
- [通过 webhook 界面连接外部触发器。](https://docs.clawd.bot/automation/webhook)
- [设置 Gmail Pub/Sub 触发器。](https://docs.clawd.bot/automation/gmail-pubsub)
- [了解 macOS 菜单栏伴侣详情。](https://docs.clawd.bot/platforms/mac/menu-bar)
- [平台指南：Windows（WSL2）](https://docs.clawd.bot/platforms/windows)、[Linux](https://docs.clawd.bot/platforms/linux)、[macOS](https://docs.clawd.bot/platforms/macos)、[iOS](https://docs.clawd.bot/platforms/ios)、[Android](https://docs.clawd.bot/platforms/android)
- [使用故障排除指南调试常见故障。](https://docs.clawd.bot/channels/troubleshooting)
- [在暴露任何内容之前查看安全指导。](https://docs.clawd.bot/gateway/security)

## 高级文档（发现 + 控制）

- [发现 + 传输](https://docs.clawd.bot/gateway/discovery)
- [Bonjour/mDNS](https://docs.clawd.bot/gateway/bonjour)
- [网关配对](https://docs.clawd.bot/gateway/pairing)
- [远程网关 README](https://docs.clawd.bot/gateway/remote-gateway-readme)
- [控制 UI](https://docs.clawd.bot/web/control-ui)
- [仪表板](https://docs.clawd.bot/web/dashboard)

## 运维和故障排除

- [健康检查](https://docs.clawd.bot/gateway/health)
- [网关锁](https://docs.clawd.bot/gateway/gateway-lock)
- [后台进程](https://docs.clawd.bot/gateway/background-process)
- [浏览器故障排除（Linux）](https://docs.clawd.bot/tools/browser-linux-troubleshooting)
- [日志记录](https://docs.clawd.bot/logging)

## 深入探讨

- [代理循环](https://docs.clawd.bot/concepts/agent-loop)
- [存在](https://docs.clawd.bot/concepts/presence)
- [TypeBox 模式](https://docs.clawd.bot/concepts/typebox)
- [RPC 适配器](https://docs.clawd.bot/reference/rpc)
- [队列](https://docs.clawd.bot/concepts/queue)

## 工作区和技能

- [技能配置](https://docs.clawd.bot/tools/skills-config)
- [默认 AGENTS](https://docs.clawd.bot/reference/AGENTS.default)
- [模板：AGENTS](https://docs.clawd.bot/reference/templates/AGENTS)
- [模板：BOOTSTRAP](https://docs.clawd.bot/reference/templates/BOOTSTRAP)
- [模板：IDENTITY](https://docs.clawd.bot/reference/templates/IDENTITY)
- [模板：SOUL](https://docs.clawd.bot/reference/templates/SOUL)
- [模板：TOOLS](https://docs.clawd.bot/reference/templates/TOOLS)
- [模板：USER](https://docs.clawd.bot/reference/templates/USER)

## 平台内部

- [macOS 开发设置](https://docs.clawd.bot/platforms/mac/dev-setup)
- [macOS 菜单栏](https://docs.clawd.bot/platforms/mac/menu-bar)
- [macOS 语音唤醒](https://docs.clawd.bot/platforms/mac/voicewake)
- [iOS 节点](https://docs.clawd.bot/platforms/ios)
- [Android 节点](https://docs.clawd.bot/platforms/android)
- [Windows（WSL2）](https://docs.clawd.bot/platforms/windows)
- [Linux 应用](https://docs.clawd.bot/platforms/linux)

## 邮件钩子（Gmail）

- [docs.clawd.bot/gmail-pubsub](https://docs.clawd.bot/automation/gmail-pubsub)

## Clawd

Clawdbot 是为 **Clawd** 构建的，一个太空龙虾 AI 助手。🦞
由 Peter Steinberger 和社区构建。

- [clawd.me](https://clawd.me)
- [soul.md](https://soul.md)
- [steipete.me](https://steipete.me)

## 社区

参见 [CONTRIBUTING.md](CONTRIBUTING.md) 了解指南、维护者以及如何提交 PR。
欢迎 AI/氛围编码的 PR！🤖

特别感谢 [Mario Zechner](https://mariozechner.at/) 的支持和
[pi-mono](https://github.com/badlogic/pi-mono)。

感谢所有 clawtributors：

<p align="left">
  <a href="https://github.com/steipete"><img src="https://avatars.githubusercontent.com/u/58493?v=4&s=48" width="48" height="48" alt="steipete" title="steipete"/></a> <a href="https://github.com/plum-dawg"><img src="https://avatars.githubusercontent.com/u/5909950?v=4&s=48" width="48" height="48" alt="plum-dawg" title="plum-dawg"/></a> <a href="https://github.com/bohdanpodvirnyi"><img src="https://avatars.githubusercontent.com/u/31819391?v=4&s=48" width="48" height="48" alt="bohdanpodvirnyi" title="bohdanpodvirnyi"/></a> <a href="https://github.com/iHildy"><img src="https://avatars.githubusercontent.com/u/25069719?v=4&s=48" width="48" height="48" alt="iHildy" title="iHildy"/></a> <a href="https://github.com/jaydenfyi"><img src="https://avatars.githubusercontent.com/u/213395523?v=4&s=48" width="48" height="48" alt="jaydenfyi" title="jaydenfyi"/></a> <a href="https://github.com/joaohlisboa"><img src="https://avatars.githubusercontent.com/u/8200873?v=4&s=48" width="48" height="48" alt="joaohlisboa" title="joaohlisboa"/></a> <a href="https://github.com/mneves75"><img src="https://avatars.githubusercontent.com/u/2423436?v=4&s=48" width="48" height="48" alt="mneves75" title="mneves75"/></a> <a href="https://github.com/MatthieuBizien"><img src="https://avatars.githubusercontent.com/u/173090?v=4&s=48" width="48" height="48" alt="MatthieuBizien" title="MatthieuBizien"/></a> <a href="https://github.com/MaudeBot"><img src="https://avatars.githubusercontent.com/u/255777700?v=4&s=48" width="48" height="48" alt="MaudeBot" title="MaudeBot"/></a> <a href="https://github.com/Glucksberg"><img src="https://avatars.githubusercontent.com/u/80581902?v=4&s=48" width="48" height="48" alt="Glucksberg" title="Glucksberg"/></a>
  <!-- 更多贡献者... -->
</p>