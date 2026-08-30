# Y1 Cover Prompt — Mock Reader Feedback Skill

> **目的**：Y1 zh-final 阶段（M2）的 cover image 生成 prompt（C+A 组合）。
> **主题**：Claude Code 子命令 `mock-reader-feedback` — 5 persona（P1-P5）跑虚拟读者试读，强制约束 LLM 默认 positive bias。
> **owner**：用户拿去 AI 工具（Midjourney / DALL-E / Imagen4 / Recraft）生成。

---

## 通用元参数（所有 variant 共享）

- **Aspect ratio**: `16:9 landscape` 或显式 `1200x630` (OG 标准)
- **Output format**: PNG 或 WebP（`render-image` hook 会再处理）
- **Style keyword**: `geek-friendly`, `technical`, `clean`, `minimalist`, `flat-vector`
- **Color palette**:
  - 背景 `#1a1d23`（深 slate）
  - accent green `#a3e635`（Hugo theme geek-green / Claude Code 绿）
  - persona 5 色：P1 红 `#ef4444`（强华陆 dev） / P2 橙 `#fb923c`（内容创作者） / P3 紫 `#a78bfa`（indie hacker） / P4 灰 `#94a3b8`（AI 怀疑者） / P5 金 `#facc15`（选型决策者）
  - warning amber `#fbbf24`
- **Avoid**: 真人照片 / 人脸 / 公司 logo / CJK 文字 / 水印 / Google Images 风格 stock photo

---

## Variant V1 — 5 persona 视角镜头（最推荐）

**Theme**: "5 个差异化视角看同一篇文章 + 强制约束 vs 默认 positive bias"

```
A minimalist flat-vector technical illustration representing "5-persona mock reader
feedback" for a Claude Code skill. At the center: a single green-tinted document icon
labeled `index.md` with subtle code-block lines visible. Five viewer-lens rectangles
arranged in a pentagonal formation around the center document, each tinted with one of
the persona colors (red P1, orange P2, purple P3, gray P4, gold P5) and labeled with
short tags like `direct_technical` / `editor-grade` / `one-liner` / `silent` /
`comparison-matrix`.

Each lens shows a different "feedback view" of the same article:
- P1 (red): magnifying glass overlay on a code block
- P2 (orange): pen annotations on margins
- P3 (purple): one short verdict line "Verdict: stay"
- P4 (gray): a faint crossed-out 5⭐ with red strike-through
- P5 (gold): a small comparison matrix icon

A subtle gray "ghost" of a single 5-star smiley face floats to the upper-left, faded
and crossed-out, representing "LLM default positive bias" being suppressed. A bright
green arrow (#a3e635) loops from this ghost back into the center document, labeled
`mock-reader-feedback/v1`.

Style: flat-vector with subtle grain, dark slate background #1a1d23. No human figures,
no screenshots, no real UI. Generous negative space at top for optional small label:
`5 personas · LLM-as-judge · YAML schema`.

Output: 1200x630 PNG, no border, no watermark, no photographic elements.
```

---

## Variant V2 — YAML schema 卡片

**Theme**: "12 字段 YAML 文档 + 5 persona tag"

```
A vintage terminal-screen render on deep slate background. Center stage: a stylized
YAML front-matter block (12 fields) in monospace font, with the `schema:
mock-reader-feedback/v1` line glowing accent green (#a3e635). Below the YAML block,
5 small persona-colored circles (P1-P5) arranged in a row, each with a one-word
feedback_style label. To the right of the YAML: a thin vertical bar chart showing
rating distribution, with bars in P1-P5 colors mostly at 3-4 height, none at 5 — the
"rating < 5" constraint visualized.

Top-right corner: a tiny ⚠️ icon with a label `rating < 5 enforced`. Bottom-left: a
smaller ghost-rendered duplicate of the same chart but with one giant 5⭐ bar — the
"without skill" baseline.

Style: monospace (JetBrains Mono / Courier), phosphor-green and amber, subtle CRT
scanline overlay (10-15% opacity), terminal aspect 16:9. No actual log lines from any
real system — purely stylized.

Output: 1200x630 PNG, optional terminal bezel at top/bottom, no watermark.
```

---

## Variant V3 — 流程拓扑

**Theme**: "7 步工作流 + 反馈循环"

```
An abstract geometric composition. A central green (#a3e635) hexagon labeled
`mock-reader-feedback` with 7 small circles around its perimeter connected by thin
arrows, representing the 7-step workflow. Each circle has a tiny icon hint:
- Step 1: package icon (pre-reqs)
- Step 2: chat bubble (trigger)
- Step 3: filter icon (persona select)
- Step 4: prompt icon (construct)
- Step 5: gear icon (run + YAML)
- Step 6: file-write icon (docs/feedback/)
- Step 7: checkmark icon (5 + 1 self-check)

Five small persona-colored threads (red/orange/purple/gray/gold) enter from the left
side and exit to the right as 5 separate feedback report icons. A faint red dashed
loop labeled "default positive bias" enters from top and is intercepted by a green
filter before reaching the central hexagon.

Style: Bauhaus / Swiss design influence, generous negative space, balanced
asymmetric composition, dark slate background. No icons except the tiny workflow
hints, no text except small monospace step labels.

Output: 1200x630 PNG, no border, no watermark.
```

---

## 生成后必查（commit 前 checklist）

| 检查 | 命令 | 期望 |
|---|---|---|
| 尺寸合规 | `sips -g pixelWidth -g pixelHeight <file>` | ≤ 1440px（§3.3.2） |
| 优化 | `./scripts/optimize-image.sh` | -30% ~ -50% 体积下降 |
| 文件大小 | `./scripts/check-image-size.sh` | cover ≤ 200KB（§3.3.5） |
| WebP + srcset | Hugo `render-image` hook | 自动（不需要人工转） |
| 占位文件名 | `y1-mock-reader-feedback-cover-v{N}.png` | kebab-case（§3.6） |
| Front matter 替换 | `cover.image` 指向新文件名 | 走 resources 处理 |
| `cover.alt` 改写 | 描述新图主题 | 英文、CJK-free（§3.3 + §3.2）|

## 替换步骤（用户生成图回来后）

```bash
# 1. 拷到 article-slug 目录
cp ~/Downloads/<user-generated>.png \
   assets/images/ai-agent/mock-reader-feedback-skill-deep-dive/y1-mock-reader-feedback-cover-v1.png

# 2. 优化（width + palette quantize）
./scripts/optimize-image.sh assets/images/ai-agent/mock-reader-feedback-skill-deep-dive/

# 3. 文件大小检查
./scripts/check-image-size.sh

# 4. 触发 [asset] commit（cover image + front matter 替换 + alt 改写）
#    Claude Code 跑 commit-with-prefix skill + 4 gates
```

---

*起草：D21 2026-08-30 · 由 C+A 组合催生 · M2 阶段 trigger：「Y1 zh-final 阶段 5 cover 入库」*