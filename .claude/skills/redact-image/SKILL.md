---
name: redact-image
description: Two-step PII redaction workflow for HeimaEden blog screenshots. Uses PIL pixel scanning (not Read tool — has caching bug) to propose --box coordinates with confidence tags, waits for user confirmation, then moves redacted file to assets/images/ and runs optimize-image.sh. Use when user says "需要脱敏" / "needs redaction" / "需要打码" / "redact this screenshot".
---

# redact-image

HeimaEden 截图 PII 脱敏 SOP（CLAUDE.md §3.3.4）。**两步流程**：AI 不能画像素，必须用户确认后跑脚本。

## 触发场景

- 用户说："需要脱敏" / "needs redaction" / "需要打码" / "redact this screenshot"
- 新截图含 UI（账户邮箱、卡号尾段、ID、姓名、电话、账号）
- 用户口头列举："needs redaction for: email, card last 8, full name"

## 为什么不能直接调脚本

**AI 不能跳过"用户确认 --box 坐标"这一步**——理由：
1. AI 看图片的 Read tool **有严重缓存 bug**（同一路径多次 Read 返回同一张图，2026-08-20 已确认）
2. 即使 PIL 像素扫描客观，仍可能误判——UI 元素看起来像 PII 但实际不是
3. §3.3.4 写死："The user makes the final call — AI redacts conservatively, not aggressively"

## 工作流（5 步）

### 1. 确认 raw 文件路径 + PIL 扫描

**输入**：用户给 raw 路径，如 `~/Downloads/raw-6.png`

```bash
# 读尺寸
sips -g pixelWidth -g pixelHeight ~/Downloads/raw-6.png

# PIL 扫描"非白像素"分布（找 PII 候选区域）
python3 <<'EOF'
from PIL import Image
img = Image.open('/Users/<user>/Downloads/raw-6.png').convert('RGB')
w, h = img.size
print(f'size: {w}x{h}')
# 扫描每一行的非白像素范围
for y in range(0, h, 10):
    non_white_x = []
    for x in range(0, w):
        r, g, b = img.getpixel((x, y))
        if not (r > 240 and g > 240 and b > 240):
            non_white_x.append(x)
    if non_white_x:
        print(f'y={y}: x range [{min(non_white_x)}, {max(non_white_x)}], count={len(non_white_x)}')
EOF
```

### 2. 列出 --box 候选 + 信心标签

**格式**：
```
- 🔴 --box X,Y,W,H   # <字段>（likely PII）
- 🟡 --box X,Y,W,H   # <字段>（could be PII）
- ⚪ --box X,Y,W,H   # <UI 元素>（背景/控件）
```

**🔴 触发**（必须打码）：
- 邮箱地址
- 卡号末 8 位
- 完整姓名（姓 + 名）
- ID 号 / SSN / 身份证
- 电话号码
- 完整账号

**🟡 触发**（半信半疑，需要用户裁断）：
- 邮箱的部分前缀
- 头像区域（如果不是公众人物）
- 地理位置（如 dashboard 显示的城市级粒度）

**⚪ 不打**：
- 纯 UI 控件（按钮、菜单、icon）
- 公开的 logo / 品牌
- 货币符号（$、¥）
- 通用问候语（"Welcome"）

### 3. WAIT 用户确认（**不跳过**）

向用户报告：

```
准备 redact ~/Downloads/raw-6.png (1634×982)
建议 --box：
  🔴 --box 0,0,1634,41      # 顶部标题栏（可能含用户名）
  🔴 --box 0,65,1634,40     # 第二行（疑似邮箱）
  🟡 --box 800,200,200,30   # 头像区域
  ⚪ 跳过：其余 UI 控件

确认后跑：
  ./scripts/redact-image.sh ~/Downloads/raw-6.png ~/Downloads/clean-6.png \
    --box 0,0,1634,41 \
    --box 0,65,1634,40 \
    --box 800,200,200,30
```

**用户必须显式 ack 才能继续**——可能是：
- "同意" / "OK" / "跑" → 执行脚本
- 调整 box 坐标 → 重新提议
- 减少 box（如"邮箱可以保留"） → 只跑 🔴 必须项

### 4. 跑 redact-image.sh（用户执行）

**用户跑**：

```bash
./scripts/redact-image.sh <raw.png> <clean.png> \
  --box X,Y,W,H \
  --box X,Y,W,H \
  ...
```

**AI 验证**（用 PIL 再次扫 clean.png）：

```bash
python3 <<'EOF'
from PIL import Image
img = Image.open('/path/to/clean.png').convert('RGB')
w, h = img.size
# 抽样每个 box 区域的中心点
for (x, y, bw, bh) in [(0,0,1634,41), ...]:
    cx, cy = x + bw//2, y + bh//2
    print(f'box ({x},{y},{bw},{bh}) center={img.getpixel((cx, cy))}')
    # 期望 RGB(0, 0, 0)
EOF
```

**期望**：每个 box 中心点 = `(0, 0, 0)`（不透明黑覆盖）。

### 5. 移动到目标路径 + 优化

```bash
# mv 到 Page Bundle 同目录或 article-specific 目录
mv ~/Downloads/clean-6.png assets/images/<category>/<article-slug>/step-N-<purpose>.png

# 必须跑 optimize（1440px ceiling）
./scripts/optimize-image.sh assets/images/<category>/<article-slug>/step-N-<purpose>.png

# 验证 ≤1440px
./scripts/optimize-image.sh --check
```

### 6. 在 .md 里加 `![alt]` 引用

按 CLAUDE.md §3.3.1 格式：

```markdown
![alt 文本（英文，无 CJK）](/images/<category>/<article-slug>/step-N-<purpose>.png)
```

## 反模式（CLAUDE.md §3.3.4）

- ❌ **Cropping instead of overlaying**——`sips -c H W` 破坏周边上下文。黑覆盖保留。
- ❌ **"Just blur lightly"**——边缘像素泄漏。黑永远；blur 永远近似。
- ❌ **"内 UI 跳过脱敏"**（Spaceship dashboard / PayPal wallet）——任何显示**你的**账户的内容仍是 PII。
- ❌ **跳过用户 review**——AI 直接跑脚本。
- ❌ **用 Read tool 验证 clean.png**——Read tool 缓存 bug 必须用 PIL。

## 硬约束引用

- **CLAUDE.md §3.3.4**：PII redact SOP 全流程
- **CLAUDE.md §3.3.2**：optimize-image.sh 1440px cap（redact 后必跑）
- **CLAUDE.md §3.3.1**：路径格式 `assets/images/<category>/<article-slug>/`
- **CLAUDE.md §4 forbidden**：未脱敏截图 commit

## 失败兜底

| 场景 | 处理 |
|---|---|
| 用户说"全部都打码" | 给所有非白像素行建议 box，仍要用户 ack |
| 用户说"邮箱可以保留" | 只跑非邮箱 box |
| raw 文件不存在 | 报告路径错误，让用户重新提供 |
| Pillow 未安装 | 报告 `pip3 install --user Pillow` |
| 用户跳过用户 review 直接说"跑" | **拒绝并提醒**——§3.3.4 写死用户必须确认 |