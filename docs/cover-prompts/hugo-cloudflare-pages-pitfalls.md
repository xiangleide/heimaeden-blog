# Cover Prompt — hugo-cloudflare-pages-pitfalls（A1）

> **目标文章**：`content/posts/static-site/hugo-cloudflare-pages-pitfalls.md`（commit `f7c1b80d` 初次发布，D3；当前 `[correction] be430eb` + `[polish] f8c5aef` 已校准根因 + 视觉净化）
>
> **风格基调**：Minimalist Cyberpunk Developer Vibe（极简高级全栈程序员黑客风）
>
> **首次落地**：2026-08-17（D6）
>
> **目的**：可复用 prompt 资产——后续姊妹篇（Cloudflare Pages 其他主题）能借鉴同一套 visual language / palette / negative prompt。

---

## 一、视觉概念设计意图

| 视觉元素 | 对应文章隐喻 |
|---|---|
| 抽象 `<>` HTML 标签重塑为**线框捕兽夹**（snap-trap） | "陷阱"主题词；闭合的夹子 = 等待踩坑的部署 |
| 沿上颚排布的 **7 颗红色 LED** | "7 Hidden Traps" 数量显式表达 |
| `#39ff14` 霓虹绿线框 | Cyberpunk 主色，克制不过饱和 |
| 底部单条 `#00d9ff` cyan 细线 | Cloudflare Pages 边缘网络 |
| 暗紫黑底色 + 扫描线 + 远处 monospace 字符流 | 程序员终端氛围，全栈开发者黑客感 |
| 无人物 / 无可读文字 / 极简负空间 | 欧美本土独立博客封面克制审美 |

---

## 二、完整 Prompt（方案 A · 可复制粘贴）

```text
Minimalist cyberpunk developer aesthetic, ultra-clean composition.

Central focal point: a large abstract HTML opening tag "<>" reimagined as a sleek snap-trap (mouse-trap jaw), rendered in thin neon-green wireframe line-art against a dark void. Seven small red LED dots are arranged along the trap's upper jaw — each LED glowing softly, symbolizing the "7 hidden traps" of Hugo + Cloudflare Pages deployment.

Background: deep matte black fading into graphite purple, overlaid with faint horizontal scanlines for a subtle CRT vibe, and a barely-visible dotted grid pattern fading toward the edges. In the far background, a few ghostly rows of dim monospace characters drift vertically. A single thin cyan accent line bisects the bottom third, evoking the edge network.

Mood: cold, technical, precise — like a senior full-stack developer's terminal at 2am after a successful debug session.

Technical specs: 16:9 widescreen aspect ratio, no human figures, no readable text anywhere (UI elements are abstract glyphs only), minimal clutter, cinematic negative space, no excessive ornamentation.

Color palette (LOCKED):
- Base: #0a0a0f deep matte black
- Atmospheric: #1a0a2e deep graphite purple
- Primary UI: #39ff14 neon green (trap wireframe + core accent)
- Trap emphasis: #ff2a3c single red (reserved for the seven LEDs only)
- Edge accent: #00d9ff faint cyan (bottom line only)

Negative prompts: photorealistic humans, faces, hand-drawn look, watercolor, cluttered UI, multiple focal points, decorative borders, frames, vintage paper texture, off-axis tilt, busy backgrounds, rainbow neon effects.
```

---

## 三、模型特定参数（生成时附加）

| 模型 | 附加参数 | 备注 |
|---|---|---|
| **Midjourney v6+** | `--ar 16:9 --style raw --s 50 --q 2` | `raw` + 低 stylize=50 出极简；`q=2` 高细节 |
| **DALL-E 3** | 选 `1792×1024` 尺寸；style 选 `vivid` 出饱和 / `natural` 出更克制 | prompt 直接贴全文 |
| **Stable Diffusion XL** | `--ar 16:9`，Cyberpunk 风格 LoRA（如 `CyberpunkAnime` / `DreamShaper`），配 ControlNet 锁色块 | 适合自托管，需要 venv |
| **Flux.1 / Recraft v3** | 自然语言直接用；强调 "ultra-minimalist" | 这俩对极简风格支持最好 |

**色彩锁是关键**：上面 5 个 hex 码决定风格基调。如果出图偏亮/偏蓝，**多半是没锁住 palette**——在生成参数里强制锁色而不是只写颜色名。

**风格微调关键词**：
- 更"安静"（接近欧美独站博客极简审美）：把 `Minimalist cyberpunk` 改成 `Minimalist tech-noir`，cyberpunk 元素自然收敛
- 更"尖锐"：MJ 加 `--chaos 15`；SDXL 加 high contrast LoRA

---

## 四、落地路径（生成后落档约定）

| 维度 | 值 |
|---|---|
| **物理路径** | `assets/images/static-site/hugo-cloudflare-pages-pitfalls/cover.jpg` |
| **front matter 引用** | `static-site/hugo-cloudflare-pages-pitfalls/cover.jpg` |
| **目录命名** | kebab-case，沿用 article filename |
| **格式** | JPG（封面图统一 JPG，screenshots 才是 PNG） |
| **尺寸上限** | 1440px（per CLAUDE.md §3.3.2，`optimize-image.sh` 会自动降采样） |

---

## 五、Alt 文本建议

欧美独立博客封面 alt 风格：**一句具体描述，不超过 200 字符**，避免 SEO 关键词堆砌。

**首选**：
> Snap-trap wireframe in neon green with seven red LEDs, evoking the hidden pitfalls of static site deployment.

**备选**（如果首选生成图与描述不符）：
> A minimalist cyberpunk illustration: a green wireframe snap-trap shape with seven red dots along its jaw, against a deep purple void.

---

## 六、Front Matter 拼接示例

```toml
[cover]
    image = "static-site/hugo-cloudflare-pages-pitfalls/cover.jpg"
    alt = "Snap-trap wireframe in neon green with seven red LEDs, evoking the hidden pitfalls of static site deployment."
```

插入位置：tags 之后、showToc 之前（与 A2/A3 当前 front matter 风格保持一致）。

---

## 七、生成后落档流程 Checklist

按顺序执行（任一步失败都先停下，**不要直接 commit**）：

- [ ] **保存原始 PNG/JPG** 到 `~/Downloads/cover-raw.png`（任意暂存路径）
- [ ] **跑优化**：`./scripts/optimize-image.sh <raw.png>` 自动降采样到 1440px ceiling（per CLAUDE.md §3.3.2）
- [ ] **移动到物理路径**：优化后的文件落到 `assets/images/static-site/hugo-cloudflare-pages-pitfalls/cover.jpg`
- [ ] **更新 A1 front matter**：加 `[cover]` 块（image + alt，按本文件 §六）
- [ ] **跑 lint**：`./scripts/lint-post.sh content/posts/static-site/hugo-cloudflare-pages-pitfalls.md`
- [ ] **跑 hugo build**：`hugo --gc`（0 errors 才算合格）
- [ ] **commit prefix**：`[asset]` 或 `[cover]`（CLAUDE.md §附 D 没列；建议新增 `[asset]` 表示"补 cover 资产"）
- [ ] **HOLD push**（per CLAUDE.md §6 所有 commit 等用户 ack）

---

## 八、复用备注

写姊妹篇（Cloudflare Pages 其他主题，例如 Worker 路由配置、CDN 缓存策略、Cloudflare R2 集成等）时，**沿用本文件的 palette + negative prompts + composition 风格**，但视觉核心需要换：

- **Worker 路由主题**：捕兽夹 → 抽象网络路由分叉（split path），7 个 routing trap 改为 "edge cases"
- **CDN 缓存主题**：捕兽夹 → 抽象缓存盒（cache box），7 traps 改为 "cache invalidation pitfalls"
- **Cloudflare R2 主题**：捕兽夹 → 抽象存储桶（bucket wireframe），7 traps 改为 "object storage pitfalls"

⚠️ **数量 7 不要硬塞**：如果姊妹篇不是 7 个 trap，改用对应数字（5 / 10 / N）替换 LED 数量即可。

---

## 附录 A · 设计取舍记录

| 取舍 | 决定 | 理由 |
|---|---|---|
| 选"捕兽夹"隐喻而非"终端撞地球" | 捕兽夹 | 极简单焦点（一物一 LED 排），比"两物相撞"叙事更稳；显式呼应 "traps" 关键词 |
| 选 neon green 单一主色（不用多色霓虹） | 单绿 | 欧美独站博客审美走"克制"而非"赛博朋克霓虹彩虹"——后者容易被归类为内容农场视觉 |
| 选 7 LED 红色而非散点 | 7 LED | 显式数量表达；红色锁定为唯一强调色（palette discipline）；其他红色干扰要进 negative prompts |
| 选无人物 | 无人物 | 抽象 glyph 优于人脸——避免"AI-Generated face"这种 Pinterest 内容农场陷阱 |
| 锁 hex code 而非仅写颜色名 | 锁 hex | 多数模型对 "neon green" 解释不一致，给 hex 才能稳定出 cyberpunk 绿 |
| 副隐喻用底部 cyan line 而非 globe | 线条 | globe 是 Cloudflare 官方图标，会撞版权；抽象线条更通用，也更克制 |
