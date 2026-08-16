#!/usr/bin/env bash
#
# optimize-image.sh — HeimaEden image pre-commit optimizer
# ---------------------------------------------------------------------------
# Purpose: cap source-image width BEFORE `git add`.
#
# Why this exists (CLAUDE.md §3.3):
#   Git cannot delta-compress binaries. Every re-crop of a screenshot stores a
#   full new blob in history, FOREVER. Committing a 2166px screenshot when the
#   theme renders at 720px permanently wastes repo space for zero visual gain.
#
# What this does NOT do:
#   WebP conversion, width/height attrs and lazy-loading are handled at BUILD
#   time by layouts/_markup/render-image.html (Hugo extended). Do not duplicate
#   that work here.
#
# Dependencies: sips (macOS built-in). No brew install required.
#
# Usage:
#   ./scripts/optimize-image.sh                 # optimize assets/images/
#   ./scripts/optimize-image.sh path/to/dir     # optimize another dir
#   ./scripts/optimize-image.sh --check         # report only, exit 1 if any
#                                               # oversized (for lint/CI)
#   ./scripts/optimize-image.sh --dry-run       # show plan, change nothing
#
# Idempotent: images already <= MAXW are skipped.

set -euo pipefail

MAXW=1440

RED=$'\033[0;31m'; GRN=$'\033[0;32m'; YLW=$'\033[0;33m'
BLU=$'\033[0;34m'; DIM=$'\033[2m';   RST=$'\033[0m'

MODE="apply"
TARGET_DIR=""

for arg in "$@"; do
    case "$arg" in
        --check)   MODE="check"   ;;
        --dry-run) MODE="dry-run" ;;
        -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        echo "${RED}Unknown flag: $arg${RST}" >&2; exit 2 ;;
        *)         TARGET_DIR="$arg" ;;
    esac
done

# Resolve default target relative to repo root, not CWD.
if [[ -z "$TARGET_DIR" ]]; then
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    TARGET_DIR="$REPO_ROOT/assets/images"
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "${RED}ERROR: not a directory: $TARGET_DIR${RST}" >&2
    exit 2
fi

command -v sips >/dev/null 2>&1 || {
    echo "${RED}ERROR: 'sips' not found (expected on macOS).${RST}" >&2
    exit 2
}

echo "${BLU}==> optimize-image${RST}  dir=${TARGET_DIR#"$PWD"/}  maxw=${MAXW}px  mode=${MODE}"
echo

total_before=0
total_after=0
n_resized=0
n_skipped=0
n_failed=0

# NUL-delimited to survive spaces in filenames.
while IFS= read -r -d '' img; do
    name="$(basename "$img")"

    width="$(sips -g pixelWidth "$img" 2>/dev/null | awk '/pixelWidth:/ {print $2}')"
    if [[ -z "$width" ]]; then
        printf '  %s%-52s unreadable (skipped)%s\n' "$RED" "$name" "$RST"
        n_failed=$((n_failed + 1))
        continue
    fi

    before=$(stat -f%z "$img")
    total_before=$((total_before + before))

    if [[ "$width" -le "$MAXW" ]]; then
        printf '  %s%-52s %5spx  ok%s\n' "$DIM" "$name" "$width" "$RST"
        total_after=$((total_after + before))
        n_skipped=$((n_skipped + 1))
        continue
    fi

    n_resized=$((n_resized + 1))

    if [[ "$MODE" != "apply" ]]; then
        printf '  %s%-52s %5spx  -> %spx  OVERSIZED%s\n' \
               "$YLW" "$name" "$width" "$MAXW" "$RST"
        total_after=$((total_after + before))
        continue
    fi

    if ! sips --resampleWidth "$MAXW" "$img" --out "$img" >/dev/null 2>&1; then
        printf '  %s%-52s resize FAILED%s\n' "$RED" "$name" "$RST"
        n_failed=$((n_failed + 1))
        total_after=$((total_after + before))
        continue
    fi

    after=$(stat -f%z "$img")
    total_after=$((total_after + after))
    saved=$(( 100 - after * 100 / before ))
    printf '  %s%-52s %5spx -> %spx  %6sKB -> %5sKB  -%s%%%s\n' \
           "$GRN" "$name" "$width" "$MAXW" \
           "$((before / 1024))" "$((after / 1024))" "$saved" "$RST"

done < <(find "$TARGET_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0)

echo
if [[ $total_before -gt 0 ]]; then
    pct=$(( 100 - total_after * 100 / total_before ))
else
    pct=0
fi

echo "${BLU}--- summary ---${RST}"
printf '  resized: %d   already-ok: %d   failed: %d\n' "$n_resized" "$n_skipped" "$n_failed"
printf '  total:   %sKB -> %sKB  (-%s%%)\n' \
       "$((total_before / 1024))" "$((total_after / 1024))" "$pct"

if [[ $n_failed -gt 0 ]]; then
    exit 2
fi

if [[ "$MODE" == "check" && $n_resized -gt 0 ]]; then
    echo
    echo "${RED}FAIL: $n_resized image(s) exceed ${MAXW}px.${RST}"
    echo "${RED}      Run ./scripts/optimize-image.sh before 'git add'.${RST}"
    exit 1
fi

if [[ "$MODE" == "apply" && $n_resized -gt 0 ]]; then
    echo
    echo "${GRN}Done. Re-run 'hugo --gc' to regenerate WebP derivatives.${RST}"
fi
