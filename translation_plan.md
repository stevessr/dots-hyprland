# 硬编码汉化计划

## 概述

本文档详细列出了将 `Translation.tr` 硬编码为中文的计划。下面是每个文件中需要替换的字符串及其对应的中文翻译。

---

### 1. `.config/quickshell/ii/modules/settings/ServicesConfig.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Audio" | "音频" |
| "Earbang protection" | "听力保护" |
| "Prevents abrupt increments and restricts volume limit" | "防止音量突增并限制最大音量" |
| "Max allowed increase" | "最大允许增量" |
| "Volume limit" | "音量上限" |
| "AI" | "人工智能" |
| "System prompt" | "系统提示" |
| "Battery" | "电池" |
| "Low warning" | "低电量警告" |
| "Critical warning" | "严重低电量警告" |
| "Automatic suspend" | "自动休眠" |
| "Automatically suspends the system when battery is low" | "电量低时自动休眠" |
| "Suspend at" | "休眠电量" |
| "Networking" | "网络" |
| "User agent (for services that require it)" | "用户代理（部分服务需要）" |
| "Resources" | "资源" |
| "Polling interval (ms)" | "轮询间隔 (毫秒)" |
| "Search" | "搜索" |
| "Use Levenshtein distance-based algorithm instead of fuzzy" | "使用基于莱文斯坦距离的算法替代模糊搜索" |
| "Could be better if you make a ton of typos,\nbut results can be weird and might not work with acronyms\n(e.g. \"GIMP\" might not give you the paint program)" | "如果你经常打错字，这个算法可能更好用，\n但结果可能比较奇怪，而且可能不支持缩写\n（例如搜索 “GIMP” 可能不会出现那个绘图程序）" |
| "Prefixes" | "前缀" |
| "Action" | "动作" |
| "Clipboard" | "剪贴板" |
| "Emojis" | "表情符号" |
| "Web search" | "网页搜索" |
| "Search engine" | "搜索引擎" |
| "Base URL" | "基础 URL" |
| "Time" | "时间" |
| "Format" | "格式" |
| "24h" | "24小时制" |
| "12h am/pm" | "12小时制 (am/pm)" |
| "12h AM/PM" | "12小时制 (AM/PM)" |

---

### 2. `.config/quickshell/ii/modules/settings/InterfaceConfig.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Policies" | "策略" |
| "Weeb" | "二次元" |
| "No" | "否" |
| "Yes" | "是" |
| "Closet" | "隐藏" |
| "AI" | "人工智能" |
| "Local only" | "仅本地" |
| "Bar" | "状态栏" |
| "Hug" | "贴合" |
| "Float" | "悬浮" |
| "Plain rectangle" | "矩形" |
| "Appearance" | "外观" |
| "Borderless" | "无边框" |
| "Show background" | "显示背景" |
| "Note: turning off can hurt readability" | "注意：关闭背景可能影响可读性" |
| "Buttons" | "按钮" |
| "Screen snip" | "截图" |
| "Color picker" | "颜色选择器" |
| "Mic toggle" | "麦克风开关" |
| "Keyboard toggle" | "键盘开关" |
| "Dark/Light toggle" | "深色/浅色切换" |
| "Workspaces" | "工作区" |
| "Tip: Hide icons and always show numbers for\nthe classic illogical-impulse experience" | "提示：隐藏图标并始终显示数字，以获得经典的 illogical-impulse 体验" |
| "Show app icons" | "显示应用图标" |
| "Always show numbers" | "始终显示数字" |
| "Workspaces shown" | "显示的工作区数量" |
| "Number show delay when pressing Super (ms)" | "按下 Super 键后显示数字的延迟 (毫秒)" |
| "Weather" | "天气" |
| "Enable" | "启用" |
| "Battery" | "电池" |
| "Low warning" | "低电量警告" |
| "Critical warning" | "严重低电量警告" |
| "Automatic suspend" | "自动休眠" |
| "Automatically suspends the system when battery is low" | "电量低时自动休眠" |
| "Suspend at" | "休眠电量" |
| "Dock" | "程序坞" |
| "Hover to reveal" | "悬停显示" |
| "Pinned on startup" | "启动时固定" |
| "On-screen display" | "屏幕显示" |
| "Timeout (ms)" | "超时 (毫秒)" |
| "Overview" | "概览" |
| "Scale (%)" | "缩放 (%)" |
| "Rows" | "行" |
| "Columns" | "列" |
| "Screenshot tool" | "截图工具" |
| "Show regions of potential interest" | "显示可能感兴趣的区域" |
| "Such regions could be images or parts of the screen that have some containment.\nMight not always be accurate.\nThis is done with an image processing algorithm run locally and no AI is used." | "这些区域可能是图像或屏幕上具有某种包含关系的区域。\n可能不总是准确。\n这是通过本地运行的图像处理算法完成的，没有使用人工智能。" |

---

### 3. `.config/quickshell/ii/modules/sidebarLeft/DescriptionBox.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "or" | "或" |

---

### 4. `.config/quickshell/ii/modules/sidebarLeft/translator/TextCanvas.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "%1 characters" | "%1 个字符" |

---

### 5. `.config/quickshell/ii/modules/sidebarLeft/AiChat.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Choose model" | "选择模型" |
| "Set the system prompt for the model." | "为模型设置系统提示。" |
| "Set API key" | "设置 API 密钥" |
| "Save chat" | "保存对话" |
| "Load chat" | "加载对话" |
| "Clear chat history" | "清除对话历史" |
| "Set temperature (randomness) of the model. Values range between 0 to 2 for Gemini, 0 to 1 for other models. Default is 0.5." | "设置模型的温度（随机性）。Gemini 的取值范围是 0 到 2，其他模型是 0 到 1。默认为 0.5。" |
| "Markdown test" | "Markdown 测试" |
| "Unknown command: " | "未知命令：" |
| "Large language models" | "大型语言模型" |
| "Type /key to get started with online models\nCtrl+O to expand the sidebar\nCtrl+P to detach sidebar into a window" | "输入 /key 开始使用在线模型\nCtrl+O 展开侧边栏\nCtrl+P 将侧边栏分离为窗口" |
| "Message the model... \"%1\" for commands" | "向模型发送消息... 输入“%1”查看命令" |
| "Load prompt from %1" | "从 %1 加载提示" |
| "Save chat to %1" | "将对话保存到 %1" |
| "Load chat from %1" | "从 %1 加载对话" |
| "Current model: %1\nSet it with %2model MODEL" | "当前模型：%1\n使用 %2model MODEL 设置" |

---

### 6. `.config/quickshell/ii/modules/sidebarLeft/Anime.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Set the current API provider" | "设置当前的 API 提供商" |
| "Clear the current list of images" | "清除当前的图像列表" |
| "Get the next page of results" | "获取下一页结果" |
| "Disable NSFW content" | "禁用 NSFW 内容" |
| "Allow NSFW content" | "允许 NSFW 内容" |
| "Unknown command: " | "未知命令：" |
| "Anime boorus" | "动漫图库" |
| "%1 queries pending" | "%1 个查询待处理" |
| "Enter tags, or \"%1\" for commands" | "输入标签，或输入“%1”查看命令" |
| "Current API endpoint: %1\nSet it with %2mode PROVIDER" | "当前 API 端点：%1\n使用 %2mode PROVIDER 设置" |
| "Allow NSFW" | "允许 NSFW" |

---

### 7. `.config/quickshell/ii/modules/sidebarLeft/anime/BooruResponse.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Page %1" | "第 %1 页" |

---

### 8. `.config/quickshell/ii/modules/sidebarLeft/anime/BooruImage.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Open file link" | "打开文件链接" |
| "Go to source (%1)" | "前往来源 (%1)" |
| "Download" | "下载" |
| "Download complete" | "下载完成" |

---

### 9. `.config/quickshell/ii/modules/sidebarLeft/Translator.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Translation goes here..." | "翻译结果将显示在此处..." |
| "Enter text to translate..." | "输入要翻译的文本..." |
| "Select Language" | "选择语言" |

---

### 10. `.config/quickshell/ii/modules/sidebarLeft/aiChat/MessageCodeBlock.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Copy code" | "复制代码" |
| "Code saved to file" | "代码已保存到文件" |
| "Saved to %1" | "已保存到 %1" |
| "Save to Downloads" | "保存到下载" |

---

### 11. `.config/quickshell/ii/modules/sidebarLeft/aiChat/MessageThinkBlock.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Chain of Thought" | "思维链" |
| "Thinking" | "思考中" |

---

### 12. `.config/quickshell/ii/modules/sidebarLeft/aiChat/AiMessage.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Interface" | "界面" |
| "Not visible to model" | "模型不可见" |
| "Copy" | "复制" |
| "Save" | "保存" |
| "Edit" | "编辑" |
| "View Markdown source" | "查看 Markdown 源码" |
| "Delete" | "删除" |

---

### 13. `.config/quickshell/ii/modules/sidebarLeft/aiChat/MessageTextBlock.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Waiting for response..." | "等待响应..." |

---

### 14. `.config/quickshell/ii/modules/sidebarLeft/SidebarLeftContent.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Intelligence" | "智能" |
| "Translator" | "翻译器" |
| "Anime" | "动漫" |

---

### 15. `.config/quickshell/ii/modules/overview/SearchWidget.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Search, calculate or run" | "搜索、计算或运行" |
| "Copy" | "复制" |
| "Math result" | "计算结果" |
| "Run" | "运行" |
| "Run command" | "运行命令" |
| "Action" | "动作" |
| "Launch" | "启动" |
| "App" | "应用" |
| "Search" | "搜索" |
| "Search the web" | "网络搜索" |

---

### 16. `.config/quickshell/ii/modules/overview/SearchItem.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "App" | "应用" |

---

### 17. `.config/quickshell/ii/modules/bar/Media.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "No media" | "无媒体" |

---

### 18. `.config/quickshell/ii/modules/bar/Bar.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Scroll to change brightness" | "滚动以更改亮度" |
| "Scroll to change volume" | "滚动以更改音量" |

---

### 19. `.config/quickshell/ii/modules/bar/weather/WeatherPopup.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "UV Index" | "紫外线指数" |
| "Wind" | "风" |
| "Precipitation" | "降水" |
| "Humidity" | "湿度" |
| "Visibility" | "能见度" |
| "Pressure" | "气压" |
| "Sunrise" | "日出" |
| "Sunset" | "日落" |

---

### 20. `.config/quickshell/ii/modules/bar/ActiveWindow.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Desktop" | "桌面" |
| "Workspace" | "工作区" |

---

### 21. `.config/quickshell/ii/settings.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Style" | "样式" |
| "Interface" | "界面" |
| "Services" | "服务" |
| "Advanced" | "高级" |
| "About" | "关于" |
| "Settings" | "设置" |
| "Edit config" | "编辑配置" |

---

### 22. `.config/quickshell/ii/services/Battery.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Low battery" | "电量低" |
| "Consider plugging in your device" | "请考虑插入充电器" |
| "Critically low battery" | "电量严重不足" |
| "Please charge!\nAutomatic suspend triggers at %1" | "请充电！\n将在 %1 时自动休眠" |

---

### 23. `.config/quickshell/ii/services/Weather.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Weather Service" | "天气服务" |
| "Cannot find a GPS service. Using the fallback method instead." | "找不到 GPS 服务。将改用备用方法。" |

---

### 24. `.config/quickshell/ii/services/Ai.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Online | Google's model\nGives up-to-date information with search." | "在线 | 谷歌模型\n通过搜索提供最新信息。" |
| "**Pricing**: free. Data used for training.\n\n**Instructions**: Log into Google account, allow AI Studio to create Google Cloud project or whatever it asks, go back and click Get API key" | "**价格**：免费。数据用于训练。\n\n**说明**：登录谷歌账户，允许 AI Studio 创建谷歌云项目或它要求的任何东西，然后返回并点击获取 API 密钥" |
| "Experimental | Online | Google's model\nCan do a little more but doesn't search quickly" | "实验性 | 在线 | 谷歌模型\n功能更多，但搜索速度较慢" |
| "Online via %1 | %2's model" | "通过 %1 在线 | %2 的模型" |
| "openrouter free" | "openrouter 免费" |
| "Local Ollama model | %1" | "本地 Ollama 模型 | %1" |
| "Loaded the following system prompt\n\n---\n\n%1" | "已加载以下系统提示\n\n---\n\n%1" |
| "The current system prompt is\n\n---\n\n%1" | "当前系统提示为\n\n---\n\n%1" |
| "To set an API key, pass it with the command\n\nTo view the key, pass \"get\" with the command<br/>\n\n### For %1:\n\n**Link**: %2\n\n%3" | "要设置 API 密钥，请随命令传递它\n\n要查看密钥，请随命令传递“get”<br/>\n\n### 对于 %1：\n\n**链接**：%2\n\n%3" |
| "<i>No further instruction provided</i>" | "<i>未提供进一步说明</i>" |
| "Online models disallowed\n\nControlled by `policies.ai` config option" | "在线模型已禁用\n\n由 `policies.ai` 配置选项控制" |
| "Model set to %1" | "模型已设置为 %1" |
| "Invalid model. Supported: \n```\n" | "无效模型。支持：\n```\n" |
| "Temperature must be between 0 and 2" | "温度必须在 0 和 2 之间" |
| "Temperature set to %1" | "温度已设置为 %1" |
| "%1 does not require an API key" | "%1 不需要 API 密钥" |
| "API key set for %1" | "已为 %1 设置 API 密钥" |
| "API key:\n\n```txt\n%1\n```" | "API 密钥：\n\n```txt\n%1\n```" |
| "No API key set for %1" | "未为 %1 设置 API 密钥" |
| "Temperature: %1" | "温度：%1" |
| "Switched to search mode. Continue with the user's request." | "已切换到搜索模式。请继续用户的请求。" |
| "Invalid arguments. Must provide `key` and `value`." | "无效参数。必须提供 `key` 和 `value`。" |
| "Unknown function call: %1" | "未知的函数调用：%1" |

---

### 25. `.config/quickshell/ii/services/KeyringStorage.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "For storing API keys and other sensitive information" | "用于存储 API 密钥和其他敏感信息" |
| "%1 Safe Storage" | "%1 安全存储" |

---

### 26. `.config/quickshell/ii/services/Booru.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "That didn't work. Tips:\n- Check your tags and NSFW settings\n- If you don't have a tag in mind, type a page number" | "操作失败。提示：\n- 检查您的标签和 NSFW 设置\n- 如果您没有特定的标签，可以输入页码" |
| "System" | "系统" |
| "All-rounder | Good quality, decent quantity" | "全能型 | 质量好，数量可观" |
| "For desktop wallpapers | Good quality" | "桌面壁纸 | 质量好" |
| "Clean stuff | Excellent quality, no NSFW" | "纯净内容 | 质量极佳，无 NSFW" |
| "The popular one | Best quantity, but quality can vary wildly" | "热门之选 | 数量最多，但质量参差不齐" |
| "The hentai one | Great quantity, a lot of NSFW, quality varies wildly" | "Hentai 之选 | 数量多，大量 NSFW，质量参差不齐" |
| "Waifus only | Excellent quality, limited quantity" | "仅限 Waifu | 质量极佳，数量有限" |
| "Large images | God tier quality, no NSFW." | "大图 | 神级画质，无 NSFW。" |
| "Provider set to " | "提供商已设置为 " |
| ". Notes for Zerochan:\n- You must enter a color\n- Set your zerochan username in `sidebar.booru.zerochan.username` config option. You [might be banned for not doing so](https://www.zerochan.net/api#:~:text=The%20request%20may%20still%20be%20completed%20successfully%20without%20this%20custom%20header%2C%20but%20your%20project%20may%20be%20banned%20for%20being%20anonymous.)!" | "。Zerochan 注意事项：\n- 您必须输入一种颜色\n- 在 `sidebar.booru.zerochan.username` 配置选项中设置您的 zerochan 用户名。否则您[可能会被封禁](https://www.zerochan.net/api#:~:text=The%20request%20may%20still%20be%20completed%20successfully%20without%20this%20custom%20header%2C%20but%20your%20project%20may%20be%20banned%20for%20being%20anonymous.)！" |
| "Invalid API provider. Supported: \n- " | "无效的 API 提供商。支持：\n- " |

---

### 27. `.config/quickshell/ii/services/MprisController.qml`

| 英文原文 | 中文翻译 |
| :--- | :--- |
| "Unknown Title" | "未知标题" |
| "Unknown Artist" | "未知艺术家" |
| "Unknown Album" | "未知专辑" |
