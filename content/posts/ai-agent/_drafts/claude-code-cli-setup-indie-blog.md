+++
title = "How to Set Up Claude Code CLI for a One-Person Overseas Tech Blog in 2026"
description = "Step-by-step Claude Code CLI installation for solo indie bloggers running an English-language tech site — no VPS, no MCP, no AI engineering background required."
date = 2026-08-17T11:00:00Z
draft = true
tags = ["Claude Code", "AI Coding Agent", "Indie Blogger", "Tutorial"]
categories = ["AI-Agent"]

ShowToc = true
TocOpen = true
hidemeta = false
comments = true
disableShare = false

[cover]
    image = "ai-agent/_drafts/claude-code-cli-setup-indie-blog/cover.png"
    alt = "Terminal window running Claude Code CLI next to an editor showing a Hugo blog post in progress."

lint_allow = ["cjk-body"]
+++

## 引言：把 Claude Code CLI 接到你的一人海外博客

本文有两类读者，主线和附录的写法不一样：

- **如果你已经在本机装好了 Claude Code CLI**（绝大多数从搜索结果进来的读者），**主线**（§步骤 1-3 + §常见错误 + §优缺点 + §组合对比）帮你做两件事：(1) 在 Hugo 博客项目里跑通端到端验证（读 `CLAUDE.md`、列 `.md` 文件、保存会话），(2) 通过单家 vs 组合的对比，决定要不要加路由层。
- **如果你第一次装 CLI**（全新笔记本、刚拿到订阅），**§附录 A** 帮你从零走到"主线 §步骤 1"那一刻。建议先按 A.1-A.3 跑完，再回到主线。

为什么这样切？已装读者打开本文不需要再花 5 分钟扫"npm 安装"的 10 行命令——你早走过了。本文主线以**已装读者视角**写，省略你已经走过的安装路径。

如果你正在经营一个一人海外技术博客（周一选关键词、周二写大纲、周三打磨、周五部署），Claude Code CLI 是把 AI 搭档直接请到本地最便宜的一条路：不用 SSH 到 VPS，不用 GitHub Action，不用 Cloudflare Worker；安装一次，在任意项目目录下敲 `claude`，就拥有了一个常驻终端的 AI agent，可以读你的 Markdown、推结构、起草正文、跑 shell。

范围明确限定在「一人 + 一台笔记本 + 一个博客」——MCP 服务器配置、多 agent 路由、自定义 hook 工程化、子 agent 编排都不在本文范围。

---

## 前置条件

开始前先确认以下四项。每一项都是硬卡点，缺一项安装就会失败或会话启动前报错。

### 1. 一个带 API 访问或 Pro/Max 订阅的 Claude 账号

- **方案 A — 按量付费 API**：注册 [Anthropic Console](https://console.anthropic.com/) 账号 → 用 Visa/Mastercard 充值至少 \$5 → 创建一个 API key（形如 `sk-ant-...`）。对每周写 1-3 篇的一人博客最便宜。
- **方案 B — Pro（\$20/月）或 Max（\$200/月）订阅**：在 [claude.ai](https://claude.ai) 订阅 → 在 profile 设置里启用开发者 CLI。月费更高但网页端也能用，且速率限制是方案 A 的 5 倍以上，浏览器端也用 Claude 的用户更划算。

### 2. Node.js 18 或更高（CLI 安装器要求）

Claude Code 通过 npm 分发，运行时前提是 Node.js。

- **macOS**（推荐）：Homebrew 安装 → `brew install node@20`
- **Linux**（Ubuntu/Debian）：用 NodeSource 二进制分发 → `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt install -y nodejs`
- **Windows**：从 [nodejs.org](https://nodejs.org/) 下官方 `.msi` 安装包

新开终端验证：

```bash
node --version   # v18.0.0 或更高
npm --version    # 10.x 或更高
```

### 3. 一个 Hugo 博客仓库（根目录有或没有 `CLAUDE.md` 均可）

如果博客没在 Git 仓库里（或者只是本地 Hugo 项目），现在初始化：

```bash
cd ~/projects/your-blog
git init
```

根目录的 `CLAUDE.md` 是可选但推荐的——Claude Code 每次会话启动都会读它，并把它内容当硬约束处理。**当前空 `CLAUDE.md` 也可以**，博客工作流成熟后再补硬约束。

### 4. 稳定的网络——地理相关注意

> ⚠️ **提示**：如果你从中国大陆、香港、澳门、俄罗斯、伊朗或任何 Anthropic API 间歇可达的区域连入，请预先准备：
> - 一条 HTTPS 代理 / VPN（CLI 1.x **暂不支持** HTTPS 代理——§步骤 2 会给环境变量兜底方案）
> - 确认所用支付方式在 Claude API 跨境结算时可用
>
> 上述以外的地区可跳过本条。

![Terminal output of `node --version` and `npm --version` showing v18+ or higher](/images/ai-agent/claude-code-cli-setup-indie-blog/prereq-node-version.png)

---

## 步骤 1：让 Claude 读你项目里的 `CLAUDE.md`

进到 Claude Code 的 REPL（提示符是 `>`），敲：

```text
Read the CLAUDE.md at the project root and summarize the hard constraints in 5 bullet points.
```

第一次在项目里跑命令时，Claude Code 会弹权限问：

```text
? Allow Bash? (y/N)
```

> 敲 `y` 回车。

如果项目里没有 `CLAUDE.md`，Claude Code 会报「file not found」——这是预期的，不影响继续。

预期输出：项目硬约束的 5 条 bullet 摘要。空 `CLAUDE.md` 输出空，是正常的。

![Claude Code REPL response showing 5 bullet points summarizing the project's hard constraints from CLAUDE.md](/images/ai-agent/claude-code-cli-setup-indie-blog/step-3-claudemd-summary.png)

---

## 步骤 2：验证 CLI 已连上文件系统

跑一个低风险的只读操作：

```text
List all .md files under content/posts/ in this project.
```

预期：Claude Code 打印一个列表（或树形）。**这证明安装完整链路通了**。如果报 "permission denied" 或 "filesystem not accessible"，跳到 §常见错误。

> 📝 **截图省略说明**：本节省略实操截图——拍这张图需要先让 Claude REPL 在你的真实博客目录里跑命令，截图会暴露未发布草稿文件名（如果你有）。如果 §步骤 1 读 `CLAUDE.md` 通了，文件系统链路就通了，本节不需要额外视觉证据。

---

## 步骤 3：保存会话，复用工作上下文

`/exit`（或 `Ctrl+D`）退出 Claude Code。CLI 自动把对话存到 `~/.claude/projects/<hashed-cwd>/<session-id>.jsonl`——这意味着明天的会话可以 `/resume` 接着上次继续，不必重读 `CLAUDE.md`。

下次启动：

```bash
cd ~/projects/your-blog
claude
```

要清会话历史（共用机器才需要）：

```bash
rm -rf ~/.claude/projects/<hash>
```

---

## 常见错误与修复

### 错误 1：`npm install -g` 之后 `claude: command not found`

> 📌 **本节面向新装机者**：如果你走的是 §附录 A.2 还没装好，这节帮你修。已经装好且 `claude --version` 能跑通的，可以跳过。

**根因**：npm 全局 prefix 不在你的 `$PATH` 里。

**修复**：

```bash
npm config get prefix   # 看 npm 全局装到哪
echo $PATH              # 看该目录在不在
# 如果 prefix 是 /usr/local 之类的但不在 $PATH，两种解法：
#   a) 直接走 prefix 下的 bin 子目录：$(npm config get prefix)/bin/claude --version
#   b) 加进 PATH（见 §附录 A.2 用户目录 prefix 兜底）
```

### 错误 2：API Key 登录后立刻 `401 Unauthorized`

> 📌 **本节面向新装机者**：setup wizard 走 API key 粘贴路径的看这里。

**根因**：API key 复制时带了首尾空白，或贴到了错的环境变量里。

**修复**：

1. 从 [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys) 重新复制 key
2. 贴到 Claude Code setup wizard 里时**确保删掉首尾空白**——不可见字符贡献了 90% 的 401 报错
3. 仍失败就重新生成 key

### 错误 3：OAuth 阶段网络超时（大陆用户）

> 📌 **本节面向新装机者 + 大陆网络环境**：OAuth 浏览器握手在这类网络下经常超时。

**根因**：Anthropic API 端点在国内间歇可达性差。

**修复**：配置 `ANTHROPIC_AUTH_TOKEN` 环境变量走 API key 直连，不走 OAuth（见 §附录 A.3 警告）。仍超时就在终端层级套 SOCKS5/HTTPS 代理（CLI 1.x 不原生支持 `HTTPS_PROXY`——可用 `proxychains4` 包一层）。

---

## 一人博客的 CLI 优先 AI 编程：优缺点

| 维度 | 优点 | 缺点 |
|---|---|---|
| **成本** | 按量 ≈ 周更 1-3 篇博客每月 \$5-15 | Max（\$200/月）对周更博客过饱和 |
| **隐私** | 所有会话数据留在 `~/.claude/` 里，除 Anthropic API 外不上云 | Anthropic 按其隐私政策保留 API 日志——处理 PII 前先审阅 |
| **速度** | 短 prompt 亚秒回应；并行读多文件 | 大上下文窗口（>100k tokens）明显变慢 |
| **集成** | 读 `CLAUDE.md`、MCP 服务器、Git、IDE 插件（VSCode、JetBrains） | 原生 MCP 配置非琐碎——不在本文范围 |
| **学习曲线** | 一条命令 `claude` 拿到 80% 价值 | 自定义 slash-command、hook、子 agent 各需独立教程 |

---

## 单家 Claude vs Claude + 第二模型组合对比

跑通上面的流程后，你已经能让 Anthropic 单一模型（Haiku / Sonnet / Opus）处理博客的全部工作。但**当一个人同时要写英文长文、做事实核查、又想在中文场景用本地工具时，单家模型会遇到瓶颈**。下面把两种主流配置做一个客观对比。

### 为什么需要"组合"

单家 Claude 的优势已在 §优缺点表格里列过，短板主要在三块：

1. **国内可达性差**：Anthropic API 端点间歇可达；纯单家配置绕不开 OAuth 网络问题
2. **成本线性扩展**：长 context（>100k tokens）跑大批量时单家 cost 陡升
3. **能力维度偏向**：对训练数据覆盖之外的任务（如垂直域查询、跨语种微妙提示）单家模型不一定最优

组合的核心思路：在 `ANTHROPIC_BASE_URL` 那一层引入一个本地代理/路由层，按任务类型路由到不同模型。

### 对比表格

| 维度 | 单家 Claude Code | Claude Code + 路由层 |
|---|---|---|
| 安装复杂度 | `npm install -g` 一条 | 装 router（需 Node 22+）+ 起本地 daemon（默认 `127.0.0.1:3456`）+ 配 Claude Code 指向它 |
| 切换模型 | 改 env var `ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN`，需重启 shell | 配置文件 / Web UI dashboard，无需重启 |
| Routing 策略 | 手动（你决策任务用哪家） | 条件路由（按 task type / prefix / header 自动选）+ 自动 fallback + 凭证池轮换 |
| Observability | 终端流式输出 | 可视化 Logs + token 计量 + cost estimate + tool call trace |
| Provider 覆盖 | 单家 + 任何兼容 Anthropic API 的 endpoint | OpenAI / Anthropic / Gemini / DeepSeek / SiliconFlow / Moonshot (Kimi) / Mistral / OpenRouter / 自定义，**100+** |
| 国内友好度 | 需代理绕 OAuth | 通过 SiliconFlow / Bailian / DeepSeek / Z.AI **直连**，绕过 Anthropic 网络可达性 |
| 第三方生态成熟度 | Anthropic 官方单一 CLI | [claude-code-router](https://github.com/musistudio/claude-code-router) **36.7k stars**；[LiteLLM](https://github.com/BerriAI/litellm) 是另一主流 |
| 学习曲线 | 30 分钟 | 1-2 小时 |
| 适用规模 | 单人博客 / 单 LLM 工作流 | 一人公司 / 多 SaaS / 多语种内容 / 高频次调用 |

### 两种实现路径

**路径 A（最朴素）— 手改环境变量**

```bash
# ~/.zshrc 默认用 Anthropic 自家
unset ANTHROPIC_BASE_URL

# 临时切到别的兼容 endpoint
export ANTHROPIC_BASE_URL=https://your-provider.example.com/v1
export ANTHROPIC_AUTH_TOKEN=sk-xxxxx
```

缺点：每次切换要重启 shell；做不到"按任务自动选"。

**路径 B（推荐常态化）— claude-code-router / LiteLLM 当 daemon**

1. `npm install -g @musistudio/claude-code-router`（需 Node 22+）
2. `ccr ui` 开 dashboard
3. Providers 里挂 Anthropic + 其他模型
4. Claude Code 把 `ANTHROPIC_BASE_URL` 指向 `http://127.0.0.1:3456`
5. 配置文件加 routing：长 context 自动转 DeepSeek、reasoning 任务保留 Claude Opus

### 价格量级参考（**2026 估值，仅作量级对比**）

| 模型 | Input ($/M tok) | Output ($/M tok) | 量级 vs Sonnet 3.5 |
|---|---|---|---|
| Claude Sonnet 3.5 | ~$3.00 | ~$15.00 | 1× |
| GPT-4o | ~$2.50 | ~$10.00 | ~0.8× |
| Gemini 1.5 Pro | ~$1.25 | ~$5.00 | ~0.4× |
| MiniMax M3 | ~$0.20 | ~$0.60 | **~1/15** |

⚠️ 价格高低是误导——贵的模型通常 reasoning / tool use / 长 context 一致性更好。**组合策略的核心是按任务分流**：低成本模型跑批改/翻译/重写，高质量模型跑 reasoning/写作/审稿。

### 选型建议（按场景）

- **每周 1-3 篇博客，全用英文**：单家 Claude Code 足够，无需路由层
- **每周 3+ 篇 + 涉及中文场景**：考虑加国产模型，手改 env var 切换
- **一人 SaaS / 跨 SaaS / 高频次 API**：必须上路由层（CCR 或 LiteLLM），否则 token 成本失控 + 单点故障率高

## 最后贴士

1. **每个项目都从一份写好的 `CLAUDE.md` 起步**。哪怕只有 10 行项目目的 + 工作流规则，Claude Code 的建议质量会显著提升。Anthropic 团队官方文档里也这么写。
2. **长会话里用 `/clear` 在不相关任务间切分**——重置对话历史，省 token。从「起草」切到「事实核查」时尤其好用。
3. **不要在一条命令里灌大文件（>50MB）给 Claude Code**——CLI 有上下文窗口护栏，但最好自觉。
4. **如果你并行多个博客项目**，每个项目放自己目录下，每个项目有自己的 `CLAUDE.md`。会话默认不跨项目串，但可以 `/resume <session-id>` 手动切换。
5. **盯 API 消耗**：`claude` 里敲 `/cost` 实时看本会话花了多少。Pro/Max 账号这部分包含在订阅里，但网页端的用量照旧计费。

---

## 结论

现在你已经用不到 10 分钟把 Claude Code CLI 接上了一人海外技术博客。明天第一件事：

```bash
cd ~/projects/your-blog
claude
```

…回到上次离开的地方，`CLAUDE.md` 约束自动加载。从这里出发，本系列的下一篇会讲**「把 Claude Code 接到你的 Hugo 博客做日常内容发布」**——发布流水线、内容自动化、TCM 风格的多 agent 工作流都在那篇登场。

---

## 附录 A：全新装机者从这里开始

> 📌 **本节读者**：第一次装 Claude Code CLI 的读者按 A.1 → A.2 → A.3 顺序跑完，再回到主线 §步骤 1。已装读者可跳过整个附录。

### A.1：动键盘前的踩坑搜索

按下任何安装命令前，先花 5 分钟扫一遍社区报告的踩坑。Claude Code 生态更新快，本文的安装路径截至 2026 年 8 月可用，但**故障模式随地区和账号年龄略有差异**。

#### 搜索关键词

| 渠道 | 关键词 |
|---|---|
| Reddit r/ClaudeAI | "claude code install failed" |
| Reddit r/webdev | "claude code review" |
| GitHub Issues（`anthropics/claude-code`） | 按最近更新时间排序 |
| GitHub Issues（任意 npm 子包） | "claude-code-cli" |
| Stack Overflow | tag:claude-code |
| Anthropic Community | 筛选未解决 |

#### 你要写下来的东西

3-5 条被引用最多的坑，每条记录：

- 一句话症状
- 链接源
- 解决方式属于操作层（安装步骤）还是环境层（OS/网络/账号）

这张清单进你的「踩坑工作文档」，装完后做交叉验证。

#### 为什么提前搜？

1. 对可能卡哪一步形成心理预期
2. 如果安装顺畅，这些坑变成正文§「社区已知问题」——EEAT 信任锚
3. 如果卡住，已有搜索上下文，不必再花 30 分钟重新 Google

![GitHub Issues page for anthropics/claude-code repository, showing open issues sorted by recent activity as a community health check before installing](/images/ai-agent/claude-code-cli-setup-indie-blog/step-0-community-search.png)

### A.2：通过 npm 安装 CLI

打开 Terminal（macOS）/ 默认 shell（Linux）/ Windows Terminal，跑：

```bash
npm install -g @anthropic-ai/claude-code
```

预期结尾输出类似：

```
+ @anthropic-ai/claude-code@X.Y.Z
added 247 packages in 18s
```

验证安装成功：

```bash
claude --version
```

预期：形如 `1.0.18` 的版本号（实际数字看安装时的最新版）。

#### macOS / Linux 上报 `EACCES` 怎么办（用户目录 prefix 兜底）

这是 **npm 全局安装最高频的失败**——npm 想往你的用户没权限的系统目录写。两种解法：

1. **加 sudo 重装**（共享机器不推荐）：

   ```bash
   sudo npm install -g @anthropic-ai/claude-code
   ```

2. **把 npm 全局前缀改到用户目录**（推荐）：

   ```bash
   mkdir -p ~/.npm-global
   npm config set prefix '~/.npm-global'
   export PATH=~/.npm-global/bin:$PATH
   # 把上面 export 行追加进 ~/.zshrc 或 ~/.bashrc 永久生效
   ```

   然后再跑 `npm install -g @anthropic-ai/claude-code`。

![Terminal showing successful `npm install -g @anthropic-ai/claude-code` output, with username and hostname redacted for privacy](/images/ai-agent/claude-code-cli-setup-indie-blog/step-1-npm-install.png)

### A.3：进入博客目录首次启动

进到 Hugo 项目根目录启动 CLI：

```bash
cd ~/projects/your-blog
claude
```

首次启动会走一个 setup wizard，问你用哪种认证方式：

```text
Welcome to Claude Code!
? Select authentication method: (Use arrow keys)
❯ Anthropic Console (API key)
  Claude Pro or Max subscription
  Bedrock (AWS)
  Vertex AI (GCP)
```

一人博客推荐路径：

- **前置条件方案 A 选了按量付费** → 这里选 `Anthropic Console (API key)`，粘贴 `sk-ant-...` key
- **前置条件方案 B 选了订阅** → 选 `Claude Pro or Max subscription`，CLI 会弹浏览器跳 claude.ai，登录、批准设备、回到终端

> ⚠️ **如果身后有防火墙**：OAuth 步骤可能超时。在 `~/.zshrc` 或 `~/.bashrc` 设 `ANTHROPIC_AUTH_TOKEN=<你的 api-key>` 环境变量，走直接 API key 登录，不走浏览器握手。改完重启终端。

完成 setup wizard 后，回到主线 §步骤 1（让 Claude 读 `CLAUDE.md`）继续。