# 🔧 HeimaEden 线上文章英文语境清洗与页脚微调任务书

> ⚠️ **【归档说明 / ARCHIVED-REJECTED — 2026-08-21（D10）】**
>
> 本任务书**未执行，永久归档**。归档原因（详见 README §6 / CLAUDE.md §3.8）：
>
> 1. **违反 §3.8 Rule 5（翻译 = 字面对应，不改写）**：
>    - 优化项 A 要求把 `generic overseas VPS` 改为 `overpriced` / `bloated legacy`——凭空添加主观贬义
>    - 优化项 B 要求把事实描述改为带"技术沮丧情绪"的戏剧化措辞——改写用户原话
> 2. **违反 §3.8 Rule 6（无锚点不写结论句）**：
>    - "95 分 / 5% 中文瑕疵" 是无量化标准的凭空打分，未提供具体段落证据
> 3. **绕过已建立的 SOP**：已有 `mock-reader-feedback` skill（commit `7d2cdee`）作为结构化读者反馈通道；正确路径是先跑 P1-P5 拿到具体反馈再决定改不改
> 4. **页脚修改建议未走扩展样式约定**：用内联 `style="..."`，与 `assets/css/extended/extended.css` 集中管理风格冲突，应作为独立 task
>
> **原始任务书内容保留在下方**，作为决策审计轨迹。本文件不入 git（保持 untracked）。

> **核磁共振诊断结果**：当前线上三篇长文整体英文水准极高（95分以上），老外常用的极客黑话（如 *sounds like a breeze*, *save your sanity*, *blazing-fast*）无缝嵌入，基本没有低级中式英语痕迹。
> **本次任务目标**：彻底清洗掉残留的 5% 中文瑕疵、进一步提炼学术句式为极客口语，并优化页脚排版间距，使全站达到 100% 欧美本土独立博客的工业级严丝合缝标准。

---

## 🛠️ 本地大模型自动化执行指令 (Agent Prompt)

请你在本地读取并分析博客项目中的相关文件，严格按照以下 3 项修正点执行全自动代码与文本重构：

### 📌 修正点 1：全量剔除《7 Hidden Traps》博文中的中文字符与标点
*   **目标文件**：`content/posts/static-site/hugo-cloudflare-pages-pitfalls.md`
*   **具体动作**：
    1. 扫描并检查文章中所有的 `Trap 1`、`Trap 4`、`Trap 5` 标题及下方正文，**彻底剔除任何残留的汉字、中文小括号、中文顿号（、）及中文标点**。
    2. 如果在第三节等地方发现了类似 `三、 步骤二：本地初始化 Hugo 静态博客与代码托管` 这样未清洗干净的旧中文导航标题，请将其顺畅地翻译重写为符合上下文的硬核英文技术标题。

### 📌 修正点 2：将学术书面句式转换为地道极客黑话
*   **目标文件**：`content/posts/static-site/` 路径下的三篇 Markdown 源码。
*   **具体动作**：优化文中带有微弱“教科书论文感”的英语词组，使其更具推特（X）或 GitHub 社区的口语化张力。请精准替换以下典型示例（或在文中寻找类似语境进行平替）：
    *   **优化项 A**：将原本的书面化表达 `generic overseas VPS` 强行优化替换为：`overpriced VPS hosting` 或 `bloated legacy VPS providers`。
    *   **优化项 B**：将原本平淡的 `forcing local cache scripts to loop back to localhost` 强行优化替换为：`trapping the browser in an endless localhost redirect loop` *(使用强烈动词如 trapping/endless 表达技术沮丧情绪)*。

### 📌 修正点 3：重构页脚布局，破除合规链接的“视觉挤压”
*   **目标文件**：`layouts/partials/footer.html`
*   **具体动作**：彻底清空原本过于紧凑的硬编码超链接区域，用带有现代 `gap` 弹性间距的 HTML 代码块进行替换，给小屏幕手机端留出完美的视觉呼吸感。
*   **替换代码块标准**：
    ```html
    <span class="footer-links" style="margin-left: 15px; display: inline-flex; gap: 16px;">
        |
        <a href="/legal/privacy-policy/" style="text-decoration: none; color: var(--secondary);">Privacy Policy</a>
        <a href="/legal/cookie-policy/" style="text-decoration: none; color: var(--secondary);">Cookie Policy</a>
        <a href="/legal/terms-of-service/" style="text-decoration: none; color: var(--secondary);">Terms of Service</a>
        <a href="/legal/affiliate-disclosure/" style="text-decoration: none; color: var(--secondary);">Affiliate Disclosure</a>
    </span>
    ```

---

