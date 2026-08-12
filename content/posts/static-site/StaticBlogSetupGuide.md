+++
title = "Zero-Cost Static Blog Deployment with Cloudflare Pages and Hugo"
description = "How to deploy a blazing-fast, secure, and completely free static tech blog using GitHub and Cloudflare's global edge network."
date = 2026-08-10T15:00:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "Static Site"]
categories = ["Static-Site"]

# 👇 PaperMod 专属友好展示模板开关
showToc = true
TocOpen = true
hidemeta = false
comments = true
disableShare = false
+++

# Cloudflare Pages + Hugo 静态博客零成本全自动搭建教程

作为程序员，网站域名买好后，千万不要花钱去买普通的海外 VPS 服务器，更不要把时间浪费在配置 Nginx、修补 Linux 漏洞上。利用 GitHub 托管代码，配合 Cloudflare Pages 的全球边缘节点，我们可以打造一个零服务器成本、毫秒级瞬开、绝对防爆挂马的极客静态技术博客。

---

## 一、 静态建站方案的优缺点对比

在做决定前，我深入对比了静态博客与传统 WordPress 动态站的优劣。作为技术人员，静态路线无疑是降维打击：

### 静态博客 VS 动态博客（WordPress）

| 比较维度 | 静态博客路线（我选的主赛道） | 动态博客路线（普通 WordPress） |
| :--- | :--- | :--- |
| **服务器成本** | 💰 **\$0 / 完全免费** | 💵 \$5 - \$20 / 每月固定支出 |
| **全球访问速度** | 🚀 **极快**（文章直接缓存在全球数百个 CDN 边缘节点，瞬开） | 🐢 **较慢**（受限于服务器机房位置及带宽，需配置复杂缓存） |
| **安全性** | 🔒 **绝对安全**（无数据库、无后台执行代码，黑客无从下手） | ⚠️ **高风险**（插件漏洞极多，容易被黑客挂马、注入灰色广告） |
| **维护成本** | ☕ **零运维**（不需要修补 Linux 漏洞，不需要管 SSL 证书） | 🛠️ **极高**（需定期备份、更新插件，防止被黑客挂马） |
| **我的核心缺点** | 修改排版和深度定制主题需要动少许代码，不适合非程序员。 | 随着文章变多，网站会变得臃肿、数据库查询变慢。 |

---

## 二、 步骤一：接管域名解析权（免费套上 Cloudflare 神盾）

1. 访问 **Cloudflare 官网**（`://cloudflare.com`）注册一个免费账户。
2. 登录后，在控制台首页点击左侧主菜单的 **Websites（网站）** 选项卡。
3. 点击 **Add a site**（添加站点）或 **Get Started**，输入我买好的域名 `heimaeden.com`。
4. 页面会弹出付费方案，**直接拉到页面最底部**，勾选 **Free（免费版，\$0/mo）**，点击继续。
5. Cloudflare 会自动扫描我原有的 DNS 记录，直接点击继续。
6. 页面会醒目地给出两个 Cloudflare 专属的 **Nameservers（名称服务器）** 地址（例如：`://cloudflare.com` / `://cloudflare.com`），将其复制下来。
7. 登录 **Spaceship 后台** ➔ 点击 Domains ➔ 找到我的域名 ➔ 点击 **Nameservers** ➔ 选择 **Custom DNS** ➔ 把这两行地址粘贴进去，删掉原有的，点击保存。

---

## 三、 步骤二：本地初始化 Hugo 静态博客与代码托管

1. **本地安装 Hugo**：打开终端，Mac 用户执行 `brew install hugo`，Windows 用户执行 `scoop install hugo`。
2. **创建项目骨架**：在终端里找一个干净的目录下执行：
   ```bash
   hugo new site heimaeden-blog --format toml
   cd heimaeden-blog
   git init
   ```
3. **下载行业顶级极客主题（PaperMod）**：由于 Git 命令行在国内克隆子模块极易超时断开，我直接采用“手工下载法”绕过：
    * 在浏览器里输入并直达下载网址：`https://github.com`
    * 下载后解压得到 `hugo-PaperMod-master` 文件夹，将其**重命名为 `PaperMod`**。
    * 将整个 `PaperMod` 文件夹直接拖进我项目的 `themes` 目录下。确保路径结构为 `/heimaeden-blog/themes/PaperMod/theme.toml`。
4. **修改全局配置**：用编辑器打开项目根目录下的 `hugo.toml`，在最下方新增一行：`theme = "PaperMod"`。
5. **新建第一篇文章**：在终端运行：
   ```bash
   hugo new posts/my-first-tech-post.md
   ```
   用编辑器打开该文件，将其头部的 `draft = true` 改为 `draft = false`。
6. **推送到 GitHub**：在 GitHub 上创建一个叫 `heimaeden-blog` 的新仓库，并在本地终端执行标准的 Git 提交流程，将代码完整推送到 GitHub。

---

## 四、 步骤三：在 Cloudflare Pages 上一键无缝上线

1. 登录 Cloudflare 后台，点击左侧菜单栏的 **Compute (Workers & Pages)**。
2. **极重要操作**：不要直接点右上角的蓝色大按钮！我第一次在这里迷路了。请看下方的【创建应用后的灰色字入口截图】，在白色卡片正下方找到那行灰色的极小字：👉 **`Looking to deploy Pages? Get started`**，点击最后的蓝色链接 **Get started**。
3. 页面跳转后，点击 **Connect to Git**（连接到 Git），授权并选择我 GitHub 里的 `heimaeden-blog` 仓库。
4. **配置编译参数（Build settings）**：
    * **Framework preset（框架预设）**：在下拉菜单里精准选择 **Hugo**。
    * **Build command（构建命令）**：选择 Hugo 后，系统会自动将输入框修正为最纯净的 **`hugo`**（不带任何 npx 前缀）。
5. **添加环境变量（防止线上版本过低报错）**：展开下方的 Environment variables，点击添加：
    * 变量名（Variable name）填：`HUGO_VERSION`
    * 值（Value）填：`0.120.0`
6. 点击最下方的 **Save and Deploy**（保存并部署）。等待 1 分钟左右，绿色进度条走完，点击自定义域名（Custom domains）绑定我的主域名 `heimaeden.com`，全站正式上线！

---

## 五、 我在静态建站阶段踩到的重磅大坑

### 坑 1：误把项目创建成了 Cloudflare Workers（找不到 Pages 入口）
* **【我踩坑时的真实界面截图】**：

    * 截图一：被误导进入的 Workers 配置界面：
      ![错误的Workers配置界面](https://incat.top)

    * 截图二：隐藏极深的 Pages 灰色文字入口：
      ![隐蔽的Pages入口界面](https://incat.top)

* **【我的踩坑经历】**：进入后台后，我下意识地点击了右上角最显眼的蓝色按钮 `Create application`。进去绑定 GitHub 后，发现配置界面里死活找不到“框架预设（Framework preset）”下拉框，只有 `Build command`（显示 None）和 `Deploy command`（显示 `npx wrangler deploy`），强行部署就会疯狂报错。
* **【我是如何解决的】**：我发现新版 Cloudflare 把控制台做成了聚合流。点击 `Create application` 后，默认进入的是 **Workers（Serverless函数部署）** 流程，而静态博客必须走 **Pages** 流程。我点击 Back 退出来，在创建页面的卡片最下方，找到了那行极小的灰色字 `Looking to deploy Pages? Get started`（如截图二所示），点击 **Get started** 链接，这才成功切进了纯净的 Pages 流程，彻底甩掉了 `wrangler` 报错。

### 坑 2：线上编译红字报错 `unmarshal failed: toml: expected character =`
* **【我的踩坑经历】**：当我第一次点击部署时，Cloudflare Pages 的部署日志里弹出了刺眼的红字报错，提示在解析 `/content/posts/my-first-tech-post.md` 的第 3 行时 TOML 解析失败。
* **【原因拆解】**：这是因为我的全局配置文件是 `hugo.toml`（TOML 格式），所以文章头部的元数据区域（Front Matter）也必须严格遵循 TOML 语法。我当时不小心把本地新建文章的头部写成了 YAML 格式（使用了冒号 `:` 赋值，如 `draft: false`），导致线上的 Hugo 编译器直接崩溃。
* **【我是如何解决的】**：我回到本地打开该 Markdown 文件，将头部用 `+++` 包裹，并将属性之间全部修改为标准的等号 `=` 赋值：
  ```toml
  +++
  title = "My First Tech Post"
  date = 2026-08-11T14:30:00Z
  draft = false
  +++
  ```
  保存后重新 `git push`，Cloudflare 瞬间秒级编译成功，我的 `heimaeden.com` 正式点亮全球！
