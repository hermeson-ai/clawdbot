#!/bin/bash
# 保存为 start-hermesonbot.sh

echo "🚀 启动 hermesonbot 服务..."

# 进入项目目录
cd /Users/genglin/Documents/Hermeson/clawdbot

# 设置环境
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# API 密钥预检查
echo "🔑 检查 API 密钥配置..."

# 定义支持的 API 密钥环境变量
API_KEYS=(
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY" 
    "ANTHROPIC_OAUTH_TOKEN"
    "GEMINI_API_KEY"
    "GROQ_API_KEY"
    "CEREBRAS_API_KEY"
    "XAI_API_KEY"
    "OPENROUTER_API_KEY"
    "MOONSHOT_API_KEY"
    "MINIMAX_API_KEY"
    "MISTRAL_API_KEY"
    "DEEPGRAM_API_KEY"
    "KIMICODE_API_KEY"
    "SYNTHETIC_API_KEY"
    "VENICE_API_KEY"
    "AI_GATEWAY_API_KEY"
)

# 检查是否有任何 API 密钥被设置
has_api_key=false
configured_providers=()

for key in "${API_KEYS[@]}"; do
    if [ -n "${!key}" ]; then
        has_api_key=true
        # 提取提供商名称（去掉 _API_KEY 后缀）
        provider_name=$(echo "$key" | sed 's/_API_KEY$//' | sed 's/_OAUTH_TOKEN$//' | tr '[:upper:]' '[:lower:]')
        configured_providers+=("$provider_name")
    fi
done

# 同时检查 auth-profiles.json 中的配置
AUTH_PROFILES="$HOME/.clawdbot/agents/main/agent/auth-profiles.json"
if [ -f "$AUTH_PROFILES" ]; then
    profile_providers=$(grep -o '"provider": "[^"]*"' "$AUTH_PROFILES" 2>/dev/null | cut -d'"' -f4 | sort -u)
    if [ -n "$profile_providers" ]; then
        has_api_key=true
        for p in $profile_providers; do
            configured_providers+=("$p")
        done
    fi
fi

if [ "$has_api_key" = false ]; then
    echo "⚠️  警告：未检测到任何 AI 模型 API 密钥！"
    echo ""
    echo "📋 支持的 AI 提供商和对应的环境变量："
    echo "   • OpenAI:     export OPENAI_API_KEY='your-key-here'"
    echo "   • Anthropic:  export ANTHROPIC_API_KEY='your-key-here'"
    echo "   • Google:     export GEMINI_API_KEY='your-key-here'"
    echo "   • Groq:       export GROQ_API_KEY='your-key-here'"
    echo "   • Cerebras:   export CEREBRAS_API_KEY='your-key-here'"
    echo "   • xAI:        export XAI_API_KEY='your-key-here'"
    echo "   • OpenRouter: export OPENROUTER_API_KEY='your-key-here'"
    echo "   • Moonshot:   export MOONSHOT_API_KEY='your-key-here'"
    echo "   • MiniMax:    export MINIMAX_API_KEY='your-key-here'"
    echo "   • Mistral:    export MISTRAL_API_KEY='your-key-here'"
    echo ""
    echo "💡 配置方法："
    echo "   1. 在终端中设置环境变量："
    echo "      export OPENAI_API_KEY='sk-your-actual-key-here'"
    echo ""
    echo "   2. 或者添加到 ~/.zshrc 或 ~/.bash_profile 中："
    echo "      echo 'export OPENAI_API_KEY=\"sk-your-actual-key-here\"' >> ~/.zshrc"
    echo "      source ~/.zshrc"
    echo ""
    echo "   3. 或者在启动时临时设置："
    echo "      OPENAI_API_KEY='sk-your-key' ./scripts/start.sh"
    echo ""
    echo "🔗 获取 API 密钥："
    echo "   • OpenAI: https://platform.openai.com/api-keys"
    echo "   • Anthropic: https://console.anthropic.com/settings/keys"
    echo "   • Google: https://aistudio.google.com/app/apikey"
    echo ""
    
    read -p "❓ 是否继续启动服务？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 启动已取消。请配置 API 密钥后重试。"
        exit 1
    fi
    echo "⚠️  继续启动，但需要在 Web 控制台中配置 API 密钥才能使用 AI 功能。"
else
    echo "✅ 检测到已配置的 AI 提供商: ${configured_providers[*]}"
fi

echo ""

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    pnpm install
fi

# 构建项目
echo "🔨 构建项目..."
pnpm build

# 启动服务
echo "🌟 启动网关服务..."

# 检查网关服务是否已安装
if ! pnpm clawdbot gateway start 2>&1 | grep -q "Restarted LaunchAgent"; then
    echo "📋 首次运行，安装网关服务..."
    pnpm clawdbot gateway install
    echo "🔄 启动网关服务..."
    pnpm clawdbot gateway start
fi

# 检查状态
echo "✅ 检查服务状态..."
pnpm clawdbot status

echo "🎉 服务已启动！访问 http://127.0.0.1:18789/ 进入控制台"

if [ "$has_api_key" = false ]; then
    echo ""
    echo "⚠️  提醒：请在 Web 控制台中配置 AI 模型 API 密钥以启用 AI 功能"
fi
