# Hub Cover Prompt — Hugo + Cloudflare Pages Troubleshooting Cluster

> **目的**：Hub `hugo-troubleshooting-hub` zh-final 阶段（M2）的 cover image 生成 prompt。
> **主题**：5 报错簇索引页 / 决策树导览 / cluster anchor（与 Spoke 单报错场景区分）。
> **owner**：用户拿去 AI 工具（Midjourney / DALL-E / Imagen4 / Recraft）生成。

---

## 通用元参数（所有 variant 共享）

- **Aspect ratio**: `16:9 landscape` 或显式 `1200x630`（OG 标准；PaperMod 也支持 1440×746 横向）
- **Output format**: PNG 或 WebP（`render-image` hook 会再处理 → WebP + srcset）
- **Style keyword**: `geek-friendly`, `technical`, `clean`, `minimalist`, `flat-vector`
- **Color palette**（与 S18 cover prompt 保持一致，便于视觉串联同一 cluster）：
  - 背景 `#1a1d23`（深 slate）
  - accent green `#a3e635`（Hugo theme geek-green = Hub 主色）
  - warning amber `#fbbf24`（stale / cache 类报错）
  - error red `#ef4444`（致命 OOM / redirect loop 类报错）
  - neutral slate `#475569`（背景辅助灰）
- **Avoid**: 真人照片 / 人脸 / 公司 logo / CJK 文字 / 水印 / Google Images 风格 stock photo

---

## Variant V1 — Hub-and-Spoke 拓扑图（最推荐 · 与 Cluster 概念强对齐）

**Theme**: 中央 Hub 节点 + 5 周边 Spoke 节点 + 决策箭头

```
A minimalist flat-vector technical illustration of a "hub-and-spoke" topology on a
dark slate (#1a1d23) background. In the center, a large hexagonal node labeled
"HUB" in monospace caps, filled with accent green (#a3e635). Five smaller
satellite nodes orbit the center in a pentagonal arrangement at equal distance,
each node rendered as a flat rectangle (3:1 ratio) in muted slate (#475569)
with one corner highlighted in either amber (#fbbf24) or red (#ef4444) to
suggest "the 5 error clusters". Thin geometric lines connect each satellite
node to the central hub, drawn in subtle off-white with slight glow, ending
in small triangular arrowheads pointing toward the hub.

Each satellite has a tiny monospace caption underneath: cluster 1, cluster 2,
cluster 3, cluster 4, cluster 5 — no other text. The composition is asymmetric:
the hub is slightly off-center (left-of-center, rule-of-thirds), with negative
space on the right third suggesting "open for new spokes".

Style: Bauhaus / Swiss design influence, flat-vector with subtle grain, no
icons beyond the hexagons/rectangles, no human figures, no real UI. Generous
negative space at top for optional small label:
`hugo + cloudflare pages — 5-error troubleshooting cluster`.

Output: 1200x630 PNG, no border, no watermark, no photographic elements.
```

---

## Variant V2 — 决策树导览（与 Hub 内部结构强对齐）

**Theme**: 顶部 Q1 节点 → 二叉分流 → 5 个 Spoke 终点

```
A minimalist flat-vector decision-tree diagram on dark slate (#1a1d23) background.
At the top-center: a single root rectangle labeled "Q1" in monospace, filled with
accent green (#a3e635). Two thin lines branch down-left and down-right with small
triangular arrowheads. Each branch ends at a smaller rectangle (Q2 / Q3), then
branches again. The tree descends through 3 levels and ends at 5 leaf rectangles
at the bottom, arranged horizontally and equally spaced — one for each of the 5
Spoke articles (clusters 1-5).

The 5 leaf rectangles are color-coded by severity: 1 in amber (#fbbf24) for
"warning", 1 in red (#ef4444) for "critical", 3 in neutral slate (#475569)
for "info". A subtle dotted line in off-white at 30% opacity connects the leaves
to a faint horizontal baseline near the bottom edge labeled "5 spokes" in
tiny monospace.

Style: monospace + flat-vector, geometric, no human figures, no real UI.
Composition centered with slight asymmetry (root slightly left-of-center).
Generous negative space at top for optional small label:
`5-error diagnostic tree — start from Q1`.

Output: 1200x630 PNG, no border, no watermark, no photographic elements.
```

---

## Variant V3 — 雷达 / 卫星星座（"many to one" 隐喻）

**Theme**: 5 报错点围绕中心（极坐标投影）

```
An abstract radar / satellite-constellation composition on dark slate (#1a1d23)
background. A central glowing focal point in accent green (#a3e635) with subtle
radial gradient (bright core, fading edge) — suggesting the "hub anchor". Five
small irregular geometric shapes (squares, triangles, hexagons in mixed sizes)
scatter around the focal point at varying distances, each connected to the
center by thin lines of varying opacity. The 5 outer shapes are color-coded:
1 in amber (#fbbf24) — warning, 1 in red (#ef4444) — critical, 3 in neutral
slate (#475569) — info.

Faint concentric circles (3 rings) in low-opacity off-white at 10-15% suggest
"detection range" without being too literal. No labels, no text, no monospace
captions — purely visual.

Style: minimalist geometric, slightly cosmic / sci-fi tone but still
flat-vector (not photorealistic). Composition centered, focal point slightly
left-of-center for asymmetric balance. Generous negative space at top for
optional small label:
`5 cluster anchors around one hub`.

Output: 1200x630 PNG, no border, no watermark, no photographic elements.
```

---

## 与 S18 cover 的视觉一致性约束

Hub cover 与 S18 cover 共享同一 color palette（`#1a1d23` / `#a3e635` / `#fbbf24` / `#ef4444`），便于读者在 cluster 内视觉串联：

| 元素 | S18 cover (stale draft) | Hub cover (cluster anchor) |
|---|---|---|
| 背景 | 深 slate `#1a1d23` | 同 |
| 主 accent | 绿 `#a3e635` (live) | 绿 `#a3e635` (hub anchor) |
| 警告 | 琥珀 `#fbbf24` (stale tag) | 琥珀 `#fbbf24` (warning cluster) |
| 错误 | 红 `#ef4444` (STALE stamp) | 红 `#ef4444` (critical cluster) |
| 视觉隐喻 | 抽屉 + 残留 + 修复箭头 | 拓扑 / 决策树 / 星座 |

避免 Hub 与 S18 在视觉上看起来「同一类问题」（避免被读者误判 Hub 只是 stale draft 的扩展）。Hub cover 应该看起来是**「上层索引」**，S18 cover 是「单报错场景」。

---

## 生成后必查（commit 前 checklist）

| 检查 | 命令 | 期望 |
|---|---|---|
| 尺寸合规 | `sips -g pixelWidth -g pixelHeight <file>` | ≤ 1440px（§3.3.2）|
| 优化 | `./scripts/optimize-image.sh assets/images/static-site/hugo-troubleshooting-hub/` | -30% ~ -50% 体积下降 |
| 文件大小 | `./scripts/check-image-size.sh` | ≤ 200KB（cover 上限 · §3.3.5）|
| WebP + srcset | Hugo `render-image` hook | 自动 |
| 文件名 | `hub-hugo-troubleshooting-cover-v{N}.png` | kebab-case（§3.6）|
| Front matter 替换 | `cover.image` 指向新文件 + 移除 `.png` → `.webp` 不需要（hook 自动）| 走 resources 处理 |
| `cover.alt` 改写 | 描述新图主题（V1 / V2 / V3 各自一段） | 英文、CJK-free（§3.3 + §3.2）|

---

## 替换步骤（用户生成图回来后）

```bash
# 1. 拷到 article-slug 目录
cp ~/Downloads/<user-generated>.png \
   assets/images/static-site/hugo-troubleshooting-hub/hub-hugo-troubleshooting-cover-v1.png

# 2. 优化（resize + compress）
./scripts/optimize-image.sh assets/images/static-site/hugo-troubleshooting-hub/

# 3. 文件大小审计（cover ≤ 200KB）
./scripts/check-image-size.sh
# 若超 200KB → 跑 PIL palette-quantize 段（CLAUDE.md §3.3.5）

# 4. 触发 [asset] commit（含 image + alt 改写）
#    Claude Code 跑 commit-with-prefix skill + 4 gates
```

---

## 3 个 variant 推荐优先级

1. **V1（Hub-and-Spoke 拓扑）**：最强烈视觉隐喻（Hub 概念直接对应 cluster 模型）；最推荐
2. **V2（决策树导览）**：与 Hub 内部 §诊断决策树 结构强对齐；次推荐
3. **V3（雷达星座）**：抽象美感强，但隐喻略弱；备选

---

*起草：D22 2026-08-31 · Hub zh-final M2 阶段 trigger：「AI cover 回来了」 · 与 S18 cover prompt 视觉一致性约束*