#!/usr/bin/env bash
# ============================================================================
# lint-post.sh — Enforce CLAUDE.md §3 hard constraints on Markdown posts.
#
# Usage:
#   ./scripts/lint-post.sh <file.md> [file2.md ...]
#   ./scripts/lint-post.sh --all         (lint every content/posts/**/*.md)
#   ./scripts/lint-post.sh --changed     (lint files changed vs main, git)
#
# Exit codes:
#   0 = clean (warnings allowed)
#   1 = errors found
#   2 = bad usage / file missing
#
# Keep in sync with ../CLAUDE.md §3 whenever constraints change.
# ============================================================================

# NOTE: deliberately no `set -e` — it interacts badly with grep -q returning 1
# when a pattern is absent. We rely on final exit code instead.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# ---- Colors ----
if [[ -t 1 ]]; then
    R=$'\033[0;31m'; Y=$'\033[0;33m'; G=$'\033[0;32m'
    B=$'\033[1m';    C=$'\033[0;36m'; N=$'\033[0m'
else
    R=''; Y=''; G=''; B=''; C=''; N=''
fi

# ---- Per-file issue collectors: parallel arrays (avoid subshell counter) ----
SEV=()
FILES_OUT=()
LNS_OUT=()
MSGS_OUT=()

add_err()  { SEV+=("ERROR"); FILES_OUT+=("$1"); LNS_OUT+=("$2"); MSGS_OUT+=("$3"); }
add_warn() { SEV+=("WARN "); FILES_OUT+=("$1"); LNS_OUT+=("$2"); MSGS_OUT+=("$3"); }

# ---- Arg parsing ----
FILES=()
case "${1:-}" in
    "")
        echo -e "${B}Usage:${N} lint-post.sh <file.md> [file2.md ...]"
        echo "       lint-post.sh --all       (lint every content/posts/**/*.md)"
        echo "       lint-post.sh --changed   (lint files changed vs main, git)"
        exit 2
        ;;
    --all)
        while IFS= read -r f; do FILES+=("$f"); done \
            < <(find content/posts -type f -name '*.md' | sort)
        ;;
    --changed)
        if ! command -v git >/dev/null 2>&1; then
            echo "ERROR: --changed requires git" >&2; exit 2
        fi
        while IFS= read -r f; do
            [[ "$f" =~ \.md$ ]] && [[ -f "$f" ]] && FILES+=("$f")
        done < <(git status --porcelain | awk '{print $2}' | sort -u)
        ;;
    --help|-h)
        sed -n '2,/^# ====/p' "$0" | head -n 18
        exit 0
        ;;
    *)
        for arg in "$@"; do
            if [[ -f "$arg" ]]; then FILES+=("$arg")
            else
                echo -e "${R}ERROR${N}: file not found: $arg" >&2
                exit 2
            fi
        done
        ;;
esac

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo -e "${Y}No markdown files matched.${N}"
    exit 0
fi

# ============================================================================
# Per-file checks
# ============================================================================
for FILE in "${FILES[@]}"; do
    BASENAME="$(basename "$FILE" .md)"

    # ---- §3.6 filename kebab-case ----
    if [[ "$BASENAME" =~ [[:space:]\‘\’] ]]; then
        add_err "$FILE" 0 "filename contains space or curly apostrophe (use kebab-case)"
    fi
    if [[ "$BASENAME" =~ [A-Z] ]]; then
        add_err "$FILE" 0 "filename has uppercase letter (use kebab-case, all lowercase)"
    fi
    CLEAN="$(printf '%s' "$BASENAME" | tr -d 'a-z0-9._-')"
    if [[ -n "$CLEAN" ]]; then
        add_warn "$FILE" 0 "filename has non-standard chars: $BASENAME (prefer a-z, 0-9, -, _)"
    fi

    # ---- §3.1 front matter must open with +++ ----
    FIRST_LINE="$(head -n1 "$FILE" 2>/dev/null || true)"
    if [[ "$FIRST_LINE" != "+++" ]]; then
        add_err "$FILE" 1 "front matter must start with +++ (got: '$FIRST_LINE')"
        continue
    fi
    CLOSE_LINE="$(awk 'NR > 1 && /^\+\+\+$/ { print NR; exit }' "$FILE")"
    if [[ -z "$CLOSE_LINE" ]]; then
        add_err "$FILE" 2 "front matter has no closing +++"
        continue
    fi
    BODY_START=$((CLOSE_LINE + 1))
    FM="$(sed -n "2,$((CLOSE_LINE-1))p" "$FILE")"
    BODY="$(tail -n +"$BODY_START" "$FILE")"

    # ---- §3.1 TOML not YAML: flag `key:` patterns in FM ----
    # Approach: look for lines that LOOK like `key:` (no =), report them.
    while IFS= read -r yaml_line; do
        [[ -z "$yaml_line" ]] && continue
        ln_no="$(echo "$yaml_line" | cut -d: -f1)"
        content="${yaml_line#*:}"
        add_err "$FILE" "$((ln_no + 1))" "YAML-style assignment in FM: ${content}"
    done < <(echo "$FM" | grep -nE '^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*:[[:space:]]*[^=]' || true)

    # ---- §3.1 required fields ----
    for FIELD in title date draft; do
        if ! grep -qE "^${FIELD}[[:space:]]*=" <<< "$FM"; then
            add_err "$FILE" 0 "front matter missing required field: ${FIELD}"
        fi
    done

    # ---- §3.1 date must be in past ----
    DATE_STR="$(grep -E '^date[[:space:]]*=' <<< "$FM" | head -n1 | sed -E 's/^date[[:space:]]*=[[:space:]]*//; s/^"//; s/"$//')"
    if [[ -n "$DATE_STR" ]] && command -v python3 >/dev/null 2>&1; then
        STATUS="$(DATE_STR="$DATE_STR" python3 <<'PY'
import os
from datetime import datetime, timezone
s = os.environ.get("DATE_STR", "").strip().strip('"')
try:
    if 'T' in s:
        dt = datetime.fromisoformat(s.replace('Z', '+00:00'))
    else:
        dt = datetime.strptime(s, '%Y-%m-%d').replace(tzinfo=timezone.utc)
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    now = datetime.now(timezone.utc)
    print('past' if dt < now else 'future')
except Exception:
    print('parse_error')
PY
        )"
        case "$STATUS" in
            future)
                add_err  "$FILE" 0 "date is in the FUTURE ($DATE_STR) — post hidden by Hugo" ;;
            parse_error)
                add_warn "$FILE" 0 "could not parse date: $DATE_STR" ;;
        esac
    fi

    # ---- §3.1 recommended fields ----
    DESC_STR="$(grep -E '^description[[:space:]]*=' <<< "$FM" | head -n1 | sed -E 's/^description[[:space:]]*=[[:space:]]*//; s/^"//; s/"$//')"
    if [[ -z "$DESC_STR" ]]; then
        add_warn "$FILE" 0 "front matter missing recommended field: description"
    elif [[ ${#DESC_STR} -gt 160 ]]; then
        add_warn "$FILE" 0 "description length is ${#DESC_STR} (>160 may be truncated in SERP)"
    fi
    for FIELD in tags categories; do
        if ! grep -qE "^${FIELD}[[:space:]]*=" <<< "$FM"; then
            add_warn "$FILE" 0 "front matter missing recommended field: ${FIELD}"
        fi
    done

    # ---- §3.2 body must be English (no CJK chars) ----
    # Allow per-file exemptions via `lint_allow = ["cjk-body"]` in TOML front matter.
    ALLOW="$(grep -E '^lint_allow[[:space:]]*=' <<< "$FM" | sed -E 's/^lint_allow[[:space:]]*=[[:space:]]*//; s/[][]//g' | grep -oE '"[^"]+"' | tr -d '"' | tr '\n' ' ' || true)"
    # Read first ~20 lines of front matter for HTML-comment fallback allow markers.
    HTML_ALLOW="$(grep -nE '<!--[[:space:]]*lint-allow:' <<< "$FM$BODY" 2>/dev/null \
        | head -5 \
        | sed -E 's/.*lint-allow:([a-z0-9_-]+).*/\1/' \
        | tr '\n' ' ' || true)"
    ALL_ALLOW=" $ALLOW $HTML_ALLOW "

    if [[ "$ALL_ALLOW" == *" cjk-body "* ]]; then
        # Skipped by per-file allow-list (grandfathered content)
        :
    else
        while IFS= read -r body_ln; do
            [[ -z "$body_ln" ]] && continue
            full_ln=$((BODY_START + body_ln - 1))
            add_err "$FILE" "$full_ln" "CJK character in body (§3.2 — final shipped content is English-only; allow with lint_allow = [\"cjk-body\"])"
        done < <(perl -CSD -ne 'print "$.\n" if /[\x{4e00}-\x{9fff}\x{3400}-\x{4dbf}\x{3040}-\x{309f}\x{30a0}-\x{30ff}\x{ff00}-\x{ffef}]/' "$FILE")
    fi

    # ---- §3.2 body should not open with H1 (# ); title is H1 ----
    FIRST_H1="$(echo "$BODY" | grep -nE '^# ' | head -n1 | cut -d: -f1)"
    if [[ -n "$FIRST_H1" ]] && [[ "$FIRST_H1" -le 5 ]]; then
        add_err "$FILE" "$((BODY_START + FIRST_H1 - 1))" "body has H1 within first 5 lines (title is already H1)"
    fi

    # ---- §3.3 image paths and alt text ----
    while IFS= read -r body_ln; do
        [[ -z "$body_ln" ]] && continue
        ln_no="$(echo "$body_ln" | cut -d: -f1)"
        content="${body_ln#*:}"
        full_ln=$((BODY_START + ln_no - 1))
        ALT="$(printf '%s' "$content" | sed -n 's/.*!\[\([^]]*\)\].*/\1/p')"
        PATH_PART="$(printf '%s' "$content" | sed -n 's/.*!\[[^]]*\](\([^)]*\)).*/\1/p')"
        if [[ -z "$PATH_PART" ]]; then continue; fi
        if [[ -z "$ALT" ]]; then
            add_err "$FILE" "$full_ln" "image missing alt text"
        fi
        if [[ "$PATH_PART" == static/* ]]; then
            add_err "$FILE" "$full_ln" "image path has 'static/' prefix (must be /images/...): $PATH_PART"
        elif [[ "$PATH_PART" == /* ]]; then
            if [[ ! "$PATH_PART" =~ ^/images/ ]]; then
                add_warn "$FILE" "$full_ln" "image path not under /images/: $PATH_PART"
            fi
        else
            add_err "$FILE" "$full_ln" "image path missing leading slash: $PATH_PART"
        fi
    done < <(echo "$BODY" | grep -nE '!\[[^]]*\]\(' || true)

    # ---- §3.5 code block language + length ----
    # Build issue lines via awk, then push via add_err/add_warn.
    while IFS='|' read -r sev file full_ln msg; do
        [[ -z "$sev" ]] && continue
        case "$sev" in
            ERROR) add_err  "$file" "$full_ln" "$msg" ;;
            WARN)  add_warn "$file" "$full_ln" "$msg" ;;
        esac
    done < <(echo "$BODY" | awk -v file="$FILE" -v bs="$BODY_START" '
        BEGIN { in_fence = 0; fence_open_ln = 0 }
        /^```$/ {
            if (in_fence == 0) {
                printf "WARN |%s|%d|code block opening missing language tag (bare ```)\n", file, bs + NR - 1
                in_fence = 1; fence_open_ln = NR
            } else {
                block_len = NR - fence_open_ln - 1
                if (block_len > 40) printf "WARN |%s|%d|code block has %d lines (>40) — wrap in <details>\n", file, bs + fence_open_ln - 1, block_len
                in_fence = 0
            }
            next
        }
        /^```[a-zA-Z0-9_+-]+/ {
            if (in_fence == 0) {
                in_fence = 1; fence_open_ln = NR
            } else {
                block_len = NR - fence_open_ln - 1
                if (block_len > 40) printf "WARN |%s|%d|code block has %d lines (>40) — wrap in <details>\n", file, bs + fence_open_ln - 1, block_len
                in_fence = 0
            }
            next
        }
    ')
done

# ============================================================================
# Print report
# ============================================================================
TOTAL_ERRORS=0
TOTAL_WARNINGS=0

# Print all issues in collection order
for i in "${!SEV[@]}"; do
    s="${SEV[$i]}"
    f="${FILES_OUT[$i]}"
    l="${LNS_OUT[$i]}"
    m="${MSGS_OUT[$i]}"
    case "$s" in
        ERROR)
            echo -e "  ${R}[ERROR]${N} $f:${l}  ${m}"
            TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
            ;;
        "WARN ")
            echo -e "  ${Y}[WARN]${N}  $f:${l}  ${m}"
            TOTAL_WARNINGS=$((TOTAL_WARNINGS + 1))
            ;;
    esac
done

echo ""
echo -e "${B}━━━ Summary ━━━${N}"
echo -e "  Files:        ${#FILES[@]}"
echo -e "  ${R}Errors${N}:     $TOTAL_ERRORS"
echo -e "  ${Y}Warnings${N}:   $TOTAL_WARNINGS"

if [[ $TOTAL_ERRORS -gt 0 ]]; then
    exit 1
fi
exit 0
