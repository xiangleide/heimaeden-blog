#!/usr/bin/env bash
#
# check-image-size.sh — HeimaEden pre-publish file-size gate
# ---------------------------------------------------------------------------
# Purpose: catch oversized images BEFORE push. Pixel dimensions are checked
#          separately by optimize-image.sh; this script enforces the FILE-
#          SIZE ceiling that the dimensions script does NOT enforce
#          (sips can resize a PNG without re-compressing its data, leaving
#          a 1440px PNG weighing 1.3MB — exactly what happened to S18's
#          cover before D20).
#
# Why this exists (CLAUDE.md §3.3.5):
#   - Cover images are loaded eagerly on every page view AND used as the
#     OG share card. The srcset fallback is the SOURCE asset itself — if
#     the source is 1.3MB, the largest srcset variant is 1.3MB.
#   - Body images are lazy-loaded, but a 1MB+ screenshot on a 4G phone
#     still hurts scroll performance.
#   - Hugo's build pipeline only RESIZES, never re-compresses source PNGs.
#     PaperMod cover.html emits only `Resize "%sx"` (no format flag), so
#     it inherits whatever compression the source had.
#
# Thresholds (single source of truth, also documented in CLAUDE.md §3.3.5):
#   cover images: warn at 150KB, ERROR at 200KB
#   body  images: warn at 350KB, ERROR at 500KB
#   "cover"      = any filename starting with `cover.` (case-insensitive)
#
# Exit codes:
#   0 = all assets under error threshold
#   1 = at least one asset over error threshold (CI / commit gate failure)
#   2 = bad usage / missing dependency
#
# Usage:
#   ./scripts/check-image-size.sh                 # audit assets/images/
#   ./scripts/check-image-size.sh path/to/dir     # audit another dir
#   ./scripts/check-image-size.sh --strict        # warn counts as error
#
# Dependencies: bash, find, stat, awk. No Python / sips / brew needed.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Color codes (suppressed when not a TTY)
if [[ -t 1 ]]; then
    RED=$'\033[0;31m'; YLW=$'\033[0;33m'; GRN=$'\033[0;32m'
    BLU=$'\033[1;34m'; DIM=$'\033[2m';   RST=$'\033[0m'
else
    RED=''; YLW=''; GRN=''; BLU=''; DIM=''; RST=''
fi

# Thresholds (KB). Keep in sync with CLAUDE.md §3.3.5.
COVER_WARN=150;  COVER_ERR=200
BODY_WARN=350;   BODY_ERR=500

STRICT=0
TARGET_DIR=""

for arg in "$@"; do
    case "$arg" in
        --strict)  STRICT=1 ;;
        -h|--help)
            sed -n '2,/^# ====/p' "$0" | head -n 24
            exit 0
            ;;
        -*) echo "${RED}Unknown flag: $arg${RST}" >&2; exit 2 ;;
        *)  TARGET_DIR="$arg" ;;
    esac
done

if [[ -z "$TARGET_DIR" ]]; then
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    TARGET_DIR="$REPO_ROOT/assets/images"
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "${RED}ERROR: not a directory: $TARGET_DIR${RST}" >&2
    exit 2
fi

echo "${BLU}==> check-image-size${RST}  dir=${TARGET_DIR#"$PWD"/}  strict=${STRICT}"
echo "    thresholds: cover warn=${COVER_WARN}KB / err=${COVER_ERR}KB | body warn=${BODY_WARN}KB / err=${BODY_ERR}KB"
echo

# Collect NUL-delimited paths (survives spaces in filenames).
n_total=0
n_ok=0
n_warn=0
n_err=0
violations=()

while IFS= read -r -d '' img; do
    n_total=$((n_total + 1))
    fname="$(basename "$img")"
    size_b=$(stat -f%z "$img")
    size_kb=$((size_b / 1024))

    # Classify: any filename starting with "cover." (case-insensitive) is a cover.
    lower=$(printf '%s' "$fname" | tr '[:upper:]' '[:lower:]')
    if [[ "$lower" == cover.* ]]; then
        kind="cover"; warn_kb=$COVER_WARN; err_kb=$COVER_ERR
    else
        kind="body";  warn_kb=$BODY_WARN;  err_kb=$BODY_ERR
    fi

    if   [[ $size_kb -gt $err_kb ]]; then
        n_err=$((n_err + 1)); violations+=("err")
        printf "  ${RED}%-5s %s %5dKB  > %dKB err  %s${RST}\n" "$kind" "[ERR]" "$size_kb" "$err_kb" "$img"
    elif [[ $size_kb -gt $warn_kb ]]; then
        if [[ $STRICT -eq 1 ]]; then
            n_err=$((n_err + 1)); violations+=("err")
            printf "  ${RED}%-5s %s %5dKB  > %dKB warn(strict)  %s${RST}\n" "$kind" "[ERR]" "$size_kb" "$warn_kb" "$img"
        else
            n_warn=$((n_warn + 1))
            printf "  ${YLW}%-5s %s %5dKB  > %dKB warn  %s${RST}\n" "$kind" "[WARN]" "$size_kb" "$warn_kb" "$img"
        fi
    else
        n_ok=$((n_ok + 1))
        printf "  ${DIM}%-5s %s %5dKB  ok  %s${RST}\n" "$kind" "[ OK]" "$size_kb" "$img"
    fi
done < <(find "$TARGET_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0)

echo
echo "${BLU}--- summary ---${RST}"
printf '  total: %d   ok: %d   warn: %d   err: %d\n' "$n_total" "$n_ok" "$n_warn" "$n_err"

if [[ $n_err -gt 0 ]]; then
    echo
    echo "${RED}FAIL: $n_err image(s) exceed the file-size error threshold.${RST}"
    echo "${RED}      Compress them BEFORE push — see CLAUDE.md §3.3.5.${RST}"
    echo "${RED}      Quick fix (PNG):  python3 -c \"from PIL import Image; import sys; \\"
    echo "${RED}        img=Image.open(sys.argv[1]); img.quantize(colors=256, method=Image.Quantize.FASTOCTREE, \\"
    echo "${RED}        dither=Image.Dither.NONE).save(sys.argv[1], 'PNG', optimize=True, compress_level=9)\" \\"
    echo "${RED}        <path/to/file.png>${RST}"
    exit 1
fi

if [[ $n_warn -gt 0 ]]; then
    echo
    echo "${YLW}WARN: $n_warn image(s) above warn threshold (still pass error gate).${RST}"
fi

echo "${GRN}All images within file-size budget.${RST}"
exit 0
