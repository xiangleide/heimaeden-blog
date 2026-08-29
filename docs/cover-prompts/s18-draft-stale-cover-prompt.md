# S18 Cover Prompt — Hugo draft stale fallback

> **目的**：S18 zh-final 阶段（M2）的 cover image 生成 prompt（C+A 组合）。
> **主题**：Hugo dev server 在 draft 切换后仍展示已发布文章（public/ fallback，3 层根因）。
> **owner**：用户拿去 AI 工具（Midjourney / DALL-E / Imagen4 / Recraft）生成。

---

## 通用元参数（所有 variant 共享）

- **Aspect ratio**: `16:9 landscape` 或显式 `1200x630` (OG 标准)
- **Output format**: PNG 或 WebP（`render-image` hook 会再处理）
- **Style keyword**: `geek-friendly`, `technical`, `clean`, `minimalist`, `flat-vector`
- **Color palette**:
  - 背景 `#1a1d23`（深 slate）
  - accent green `#a3e635`（Hugo theme geek-green）
  - warning amber `#fbbf24`
  - error red `#ef4444`
- **Avoid**: 真人照片 / 人脸 / 公司 logo / CJK 文字 / 水印 / Google Images 风格 stock photo

---

## Variant V1 — 隐喻插画（最推荐）

**Theme**: "draft 抽屉 + 残留文件溢出 + 修复箭头"

```
A minimalist flat-vector technical illustration representing "stale draft leak" in a
static site generator's dev server. On the left side, a steel-gray filing cabinet
labeled `content/posts/` with one drawer half-open labeled `draft`. From the half-open
drawer several green-tinted document icons labeled `index.html` slip outward and down,
falling into a darker archival zone below. One document in the lower zone has a warning
amber tag and an oversized red `STALE` stamp overlapping it. A bright green arrow from
the lower zone points back up to a fresh clean drawer on the right side labeled
`fresh build/`.

Style: flat-vector with subtle grain, dark slate background #1a1d23, accent green
#a3e635 for live content, amber #fbbf24 for warning, red #ef4444 for stale. No human
figures, no screenshots, no real UI. Generous negative space at top for optional small
label: `hugo draft still showing — public/ fallback`.

Output: 1200x630 PNG, no border, no watermark, no photographic elements.
```

---

## Variant V2 — 终端风

**Theme**: 终端屏错误 + 清理后绿勾

```
A vintage terminal-screen render on deep slate background. Top line:
`$ hugo server --buildDrafts=false`. Below: a flickering red WARN line reading
`WARN: stale fallback served for /posts/<slug>/ — public/index.html not rebuilt`.
A faded ghost of the path `/posts/.../index.html` hovers below. A green check-mark
and cursor blinking at the bottom-right showing:
`[✓ cleaned] hugo server --gc — public/{posts,tags,categories}`.

Style: monospace (JetBrains Mono / Courier), dim phosphor-green and amber, subtle CRT
scanline overlay (10-15% opacity), terminal aspect 16:9. No actual log lines from any
real system — purely stylized.

Output: 1200x630 PNG, optional terminal bezel at top/bottom, no watermark.
```

---

## Variant V3 — 极简几何

**Theme**: 重叠矩形场（archive）+ 突出 amber（stale）+ 干净绿（after）

```
An abstract geometric composition. Left half: a large overlapping rectangle field in
muted gray-blue (#475569), suggesting "tombed archives", with one smaller rectangle
pushed forward in warning amber (#fbbf24), clearly distinct from the field. A thin
diagonal red (#ef4444) line cuts across that amber rectangle. Right half: same area
but rendered as a single clean green (#a3e635) rectangle, no overlap, signifying
"after cleanup". A small white arrow bridges the half-vertical divider from left to
right with a tiny monospace hint label: `rm -rf public/`.

Style: Bauhaus / Swiss design influence, generous negative space, balanced asymmetric
composition, dark slate background. No icons, no text except the small monospace
hint label.

Output: 1200x630 PNG, no border, no watermark.
```

---

## 生成后必查（commit 前 checklist）

| 检查 | 命令 | 期望 |
|---|---|---|
| 尺寸合规 | `sips -g pixelWidth -g pixelHeight <file>` | ≤ 1440px（§3.3.2） |
| 优化 | `./scripts/optimize-image.sh` | -30% ~ -50% 体积下降 |
| WebP + srcset | Hugo `render-image` hook | 自动（不需要人工转） |
| 占位文件名 | `s18-draft-stale-cover-v{N}.png` | kebab-case（§3.6） |
| Front matter 替换 | `cover.image` 指向新文件名 | 走 resources 处理 |
| `cover.alt` 改写 | 描述新图主题 | 英文、CJK-free（§3.3 + §3.2）|

## 替换步骤（用户生成图回来后）

```bash
# 1. 拷到 article-slug 目录
cp ~/Downloads/<user-generated>.png \
   assets/images/static-site/hugo-draft-stale-dev-server-fix/s18-draft-stale-cover-v1.png

# 2. 优化
./scripts/optimize-image.sh assets/images/static-site/hugo-draft-stale-dev-server-fix/

# 3. 触发 [polish] commit（含 image replace + alt 改写）
#    Claude Code 跑 commit-with-prefix skill + 4 gates
```

---

*起草：D19 2026-08-28 · 由 C+A 组合催生 · M2 阶段 trigger：「AI cover 回来了」
