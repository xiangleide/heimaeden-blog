#!/usr/bin/env bash
#
# redact-image.sh — HeimaEden PII redaction helper
# ---------------------------------------------------------------------------
# Purpose: paint opaque black rectangles over sensitive regions of a screenshot
# BEFORE it enters the project as a content image.
#
# Why this exists (CLAUDE.md §3.3 + §3.8 rule 6):
#   Once a screenshot with real PII (email, ID, card, account number) is
#   pushed to a public Git repo + CDN, it's permanently in the wild.
#   Redaction is a one-way door — there is no "recall". Do it before commit.
#
# What this does NOT do:
#   - Coordinate inference: you always supply --box explicitly
#   - PII detection: that's the human/AI pre-flight check, not this script
#   - WebP conversion / optimization: see scripts/optimize-image.sh and
#     layouts/_markup/render-image.html
#
# Dependencies: python3 + Pillow (`pip3 install --user Pillow`).
#
# Usage:
#   ./scripts/redact-image.sh <input.png> <output.png> \
#     --box X,Y,W,H [--box X,Y,W,H ...]
#
# Coordinates are pixels relative to <input.png>'s natural dimensions.
# Use the AI / Preview / `sips -g pixelWidth -g pixelHeight` to find them.
#
# Example: cover an email visible at top-left (x=340, y=52, 180x18 px):
#   ./scripts/redact-image.sh raw.png clean.png --box 340,52,180,18

set -euo pipefail

RED=$'\033[0;31m'; GRN=$'\033[0;32m'; YLW=$'\033[0;33m'
BLU=$'\033[0;34m'; RST=$'\033[0m'

usage() {
    sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

if [[ $# -lt 3 ]]; then usage 1; fi

INPUT="$1"; shift
OUTPUT="$1"; shift

# ---- arg parsing -----------------------------------------------------------
BOXES=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --box) BOXES+=("$2"); shift 2 ;;
        -h|--help) usage 0 ;;
        *)        echo "${RED}Unknown arg: $1${RST}" >&2; usage 1 ;;
    esac
done

if [[ ${#BOXES[@]} -eq 0 ]]; then
    echo "${RED}ERROR: at least one --box X,Y,W,H is required${RST}" >&2
    exit 1
fi

if [[ "$INPUT" == "$OUTPUT" ]]; then
    echo "${RED}ERROR: input and output paths must differ (would overwrite source)${RST}" >&2
    exit 1
fi

if [[ ! -f "$INPUT" ]]; then
    echo "${RED}ERROR: input not found: $INPUT${RST}" >&2
    exit 1
fi

if [[ ! "$OUTPUT" == *.png ]]; then
    echo "${YLW}WARNING: output is not .png — overriding to .png (lossless for redaction)${RST}" >&2
    OUTPUT="${OUTPUT%.*}.png"
fi

command -v python3 >/dev/null 2>&1 || {
    echo "${RED}ERROR: python3 not found${RST}" >&2; exit 1; }

python3 -c "from PIL import Image" 2>/dev/null || {
    echo "${RED}ERROR: Pillow not installed. Run: pip3 install --user Pillow${RST}" >&2
    exit 1; }

# ---- delegate to python (keeps deps in one file) --------------------------
INPUT="$INPUT" OUTPUT="$OUTPUT" python3 - <<PYEOF
import os, sys
from PIL import Image, ImageDraw

input_path  = os.environ["INPUT"]
output_path = os.environ["OUTPUT"]
boxes_arg   = """${BOXES[*]}""".strip()

img = Image.open(input_path).convert("RGBA")
W, H = img.size
print(f"  image: {W}x{H}")

overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
draw = ImageDraw.Draw(overlay)

applied = 0
for spec in boxes_arg.split():
    try:
        x, y, w, h = (int(v) for v in spec.split(","))
    except ValueError:
        print(f"  {os.environ.get('RED','') }BAD box syntax (need x,y,w,h ints): {spec}", file=sys.stderr)
        sys.exit(2)

    if w <= 0 or h <= 0:
        print(f"  BAD box (w/h must be > 0): {spec}", file=sys.stderr); sys.exit(2)
    if x < 0 or y < 0 or x + w > W or y + h > H:
        print(f"  BAD box (out of bounds {W}x{H}): {spec}", file=sys.stderr); sys.exit(2)

    draw.rectangle([x, y, x + w, y + h], fill=(0, 0, 0, 255))
    print(f"  + box {spec}  ({x},{y}) {w}x{h}")
    applied += 1

out = Image.alpha_composite(img, overlay).convert("RGB")
out.save(output_path, "PNG", optimize=True)
print(f"  applied {applied} box(es)")
PYEOF

echo "${GRN}Done: $OUTPUT${RST}"
ls -la "$OUTPUT" | awk '{printf "  size: %s bytes\n", $5}'