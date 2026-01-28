// 国际化配置文件
export type Language = 'en' | 'zh';

export interface I18nConfig {
  // 导航和标题
  navigation: {
    chat: string;
    control: string;
    agent: string;
    settings: string;
    overview: string;
    channels: string;
    instances: string;
    sessions: string;
    cron: string;
    skills: string;
    nodes: string;
    config: string;
    debug: string;
    logs: string;
  };
  
  // 标题和副标题
  titles: {
    overview: string;
    channels: string;
    instances: string;
    sessions: string;
    cron: string;
    skills: string;
    nodes: string;
    chat: string;
    config: string;
    debug: string;
    logs: string;
  };
  
  // 副标题描述
  subtitles: {
    overview: string;
    channels: string;
    instances: string;
    sessions: string;
    cron: string;
    skills: string;
    nodes: string;
    chat: string;
    config: string;
    debug: string;
    logs: string;
  };
  
  // 通用界面文本
  ui: {
    gatewayDashboard: string;
    health: string;
    ok: string;
    offline: string;
    expandSidebar: string;
    collapseSidebar: string;
    darkMode: string;
    lightMode: string;
    systemMode: string;
    language: string;
    english: string;
    chinese: string;
  };
  
  // 状态和消息
  status: {
    connected: string;
    disconnected: string;
    loading: string;
    error: string;
    success: string;
    warning: string;
  };
}

// 英文配置
const enConfig: I18nConfig = {
  navigation: {
    chat: 'Chat',
    control: 'Control',
    agent: 'Agent',
    settings: 'Settings',
    overview: 'Overview',
    channels: 'Channels',
    instances: 'Instances',
    sessions: 'Sessions',
    cron: 'Cron Jobs',
    skills: 'Skills',
    nodes: 'Nodes',
    config: 'Config',
    debug: 'Debug',
    logs: 'Logs',
  },
  
  titles: {
    overview: 'Overview',
    channels: 'Channels',
    instances: 'Instances',
    sessions: 'Sessions',
    cron: 'Cron Jobs',
    skills: 'Skills',
    nodes: 'Nodes',
    chat: 'Chat',
    config: 'Config',
    debug: 'Debug',
    logs: 'Logs',
  },
  
  subtitles: {
    overview: 'Gateway status, entry points, and a fast health read.',
    channels: 'Manage channels and settings.',
    instances: 'Presence beacons from connected clients and nodes.',
    sessions: 'Inspect active sessions and adjust per-session defaults.',
    cron: 'Schedule wakeups and recurring agent runs.',
    skills: 'Manage skill availability and API key injection.',
    nodes: 'Paired devices, capabilities, and command exposure.',
    chat: 'Direct gateway chat session for quick interventions.',
    config: 'Edit ~/.clawdbot/clawdbot.json safely.',
    debug: 'Gateway snapshots, events, and manual RPC calls.',
    logs: 'Live tail of the gateway file logs.',
  },
  
  ui: {
    gatewayDashboard: 'Gateway Dashboard',
    health: 'Health',
    ok: 'OK',
    offline: 'Offline',
    expandSidebar: 'Expand sidebar',
    collapseSidebar: 'Collapse sidebar',
    darkMode: 'Dark mode',
    lightMode: 'Light mode',
    systemMode: 'System mode',
    language: 'Language',
    english: 'English',
    chinese: '中文',
  },
  
  status: {
    connected: 'Connected',
    disconnected: 'Disconnected',
    loading: 'Loading',
    error: 'Error',
    success: 'Success',
    warning: 'Warning',
  },
};

// 中文配置
const zhConfig: I18nConfig = {
  navigation: {
    chat: '聊天',
    control: '控制',
    agent: '智能体',
    settings: '设置',
    overview: '概览',
    channels: '通道',
    instances: '实例',
    sessions: '会话',
    cron: '定时任务',
    skills: '技能',
    nodes: '节点',
    config: '配置',
    debug: '调试',
    logs: '日志',
  },
  
  titles: {
    overview: '概览',
    channels: '通道管理',
    instances: '实例状态',
    sessions: '会话管理',
    cron: '定时任务',
    skills: '技能管理',
    nodes: '节点管理',
    chat: '聊天',
    config: '配置',
    debug: '调试',
    logs: '日志',
  },
  
  subtitles: {
    overview: '网关状态、入口点和快速健康检查。',
    channels: '管理通道和设置。',
    instances: '来自连接的客户端和节点的存在信标。',
    sessions: '检查活动会话并调整每个会话的默认设置。',
    cron: '安排唤醒和定期智能体运行。',
    skills: '管理技能可用性和 API 密钥注入。',
    nodes: '配对设备、功能和命令暴露。',
    chat: '直接网关聊天会话，用于快速干预。',
    config: '安全编辑 ~/.clawdbot/clawdbot.json。',
    debug: '网关快照、事件和手动 RPC 调用。',
    logs: '网关文件日志的实时跟踪。',
  },
  
  ui: {
    gatewayDashboard: '网关控制台',
    health: '健康状态',
    ok: '正常',
    offline: '离线',
    expandSidebar: '展开侧边栏',
    collapseSidebar: '收起侧边栏',
    darkMode: '深色模式',
    lightMode: '浅色模式',
    systemMode: '跟随系统',
    language: '语言',
    english: 'English',
    chinese: '中文',
  },
  
  status: {
    connected: '已连接',
    disconnected: '已断开',
    loading: '加载中',
    error: '错误',
    success: '成功',
    warning: '警告',
  },
};

// 语言配置映射
const configs: Record<Language, I18nConfig> = {
  en: enConfig,
  zh: zhConfig,
};

// 当前语言状态
let currentLanguage: Language = 'en';

// 获取当前语言
export function getCurrentLanguage(): Language {
  return currentLanguage;
}

// 设置语言
export function setLanguage(lang: Language): void {
  currentLanguage = lang;
  // 保存到本地存储
  localStorage.setItem('clawdbot-language', lang);
  // 触发语言变更事件
  window.dispatchEvent(new CustomEvent('languageChanged', { detail: lang }));
}

// 初始化语言（从本地存储读取）
export function initLanguage(): Language {
  const saved = localStorage.getItem('clawdbot-language') as Language;
  if (saved && (saved === 'en' || saved === 'zh')) {
    currentLanguage = saved;
  } else {
    // 根据浏览器语言自动检测
    const browserLang = navigator.language.toLowerCase();
    currentLanguage = browserLang.startsWith('zh') ? 'zh' : 'en';
  }
  return currentLanguage;
}

// 获取翻译文本
export function t(key: string): string {
  const config = configs[currentLanguage];
  const keys = key.split('.');
  let value: any = config;
  
  for (const k of keys) {
    if (value && typeof value === 'object' && k in value) {
      value = value[k];
    } else {
      console.warn(`Translation key not found: ${key}`);
      return key; // 返回原始 key 作为后备
    }
  }
  
  return typeof value === 'string' ? value : key;
}

// 获取所有支持的语言
export function getSupportedLanguages(): Array<{ code: Language; name: string }> {
  return [
    { code: 'en', name: 'English' },
    { code: 'zh', name: '中文' },
  ];
}