#!/usr/bin/env bash
#
# fetch-persona-data.sh — HeimaEden reader persona data fetcher
# ---------------------------------------------------------------------------
# Purpose: refresh docs/persona-data.json with fresh data from GSC / CF
# Analytics / Reddit / Plausible. Default mode reads the cache so the
# mock-reader-feedback skill works without any API wiring.
#
# Why this exists (CLAUDE.md §3 + docs/mock-reader-personas.md):
#   The mock-reader-feedback skill needs persona data to ground its prompts.
#   Without real data, the skill falls back to roleplay personas. With real
#   data, the same prompt slot is filled by GSC search queries, CF Analytics
#   geo/device, etc. — dramatically more useful for article iteration.
#
# v1 scope (D6 2026-08-20):
#   - Default: validate docs/persona-data.json, print summary, exit 0
#   - --live: attempt API call for the source (GSC only in v1)
#   - Other 3 sources (cf_analytics, reddit_hn_github, plausible): stub with
#     a clear "not yet implemented" message + dependency pointers
#
# To wire GSC for v1.1+, follow docs/gsc-setup-guide.md.
#
# Usage:
#   ./scripts/fetch-persona-data.sh                    # default: read cache
#   ./scripts/fetch-persona-data.sh --check            # verify cache schema
#   ./scripts/fetch-persona-data.sh --live --source=gsc
#   ./scripts/fetch-persona-data.sh --live --source=all
#   ./scripts/fetch-persona-data.sh --dry-run --live --source=gsc
#
# Exit codes:
#   0 = success
#   1 = missing dependency
#   2 = cache file missing or malformed
#   3 = requested source not implemented in v1
#   4 = API auth failure
#   5 = API quota / network error

set -euo pipefail

RED=$'\033[0;31m'; GRN=$'\033[0;32m'; YLW=$'\033[0;33m'
BLU=$'\033[0;34m'; RST=$'\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CACHE_FILE="$REPO_ROOT/docs/persona-data.json"
GSC_KEY_FILE="$REPO_ROOT/scripts/gsc-key.json"

MODE="default"
SOURCE="all"
DRY_RUN=0

usage() {
    sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

# ---- arg parsing -----------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --live)        MODE="live"; shift ;;
        --check)       MODE="check"; shift ;;
        --source=*)    SOURCE="${1#*=}"; shift ;;
        --dry-run)     DRY_RUN=1; shift ;;
        -h|--help)     usage 0 ;;
        *)             echo -e "${RED}Unknown arg: $1${RST}" >&2; usage 1 ;;
    esac
done

# ---- helpers ---------------------------------------------------------------
log()   { echo -e "${BLU}[persona-data]${RST} $*"; }
ok()    { echo -e "${GRN}[persona-data] ✓${RST} $*"; }
warn()  { echo -e "${YLW}[persona-data] ⚠${RST} $*"; }
fail()  { echo -e "${RED}[persona-data] ✗${RST} $*"; exit "${2:-1}"; }

# ---- preflight: cache file -------------------------------------------------
require_cache() {
    [[ -f "$CACHE_FILE" ]] || fail "cache not found: $CACHE_FILE" 2
    python3 -c "import json; json.load(open('$CACHE_FILE'))" \
        || fail "cache is not valid JSON: $CACHE_FILE" 2
}

# ---- default mode: read cache + summary -----------------------------------
run_default() {
    log "mode: default (read cache)"
    require_cache
    python3 - "$CACHE_FILE" <<'PY'
import json, sys
with open(sys.argv[1]) as f:
    data = json.load(f)
personas = data.get("personas", {})
sources = data.get("data_sources", {})
print(f"  version: {data.get('version', '?')}")
print(f"  last_updated: {data.get('last_updated', '?')}")
print(f"  personas: {len(personas)} ({', '.join(sorted(personas.keys()))})")
print(f"  data_sources:")
for k, v in sources.items():
    is_mock = str(v).startswith("[MOCK]")
    marker = "[MOCK]" if is_mock else "[LIVE]"
    detail = str(v).replace("[MOCK] ", "").replace("[LIVE] ", "")
    print(f"    {k}: {marker} {detail}")
PY
    ok "cache OK — no API call made"
    log "next: ./scripts/fetch-persona-data.sh --live --source=gsc (after GSC setup)"
}

# ---- check mode: validate schema only -------------------------------------
run_check() {
    log "mode: check (validate cache only)"
    require_cache
    python3 - "$CACHE_FILE" <<'PY'
import json, sys
with open(sys.argv[1]) as f:
    data = json.load(f)
required_top = {"version", "last_updated", "data_sources", "personas"}
missing = required_top - set(data.keys())
if missing:
    print(f"MISSING top-level keys: {missing}", file=sys.stderr)
    sys.exit(2)
for pid, p in data["personas"].items():
    required_persona = {"label", "geo_distribution", "device_split", "top_search_queries", "primary_intent", "feedback_style"}
    miss = required_persona - set(p.keys())
    if miss:
        print(f"persona {pid} missing: {miss}", file=sys.stderr)
        sys.exit(2)
print("schema OK")
PY
    ok "cache schema valid"
}

# ---- live mode: API call (GSC only in v1) ----------------------------------
gsc_deps_check() {
    local missing=0
    python3 -c "import google.auth" 2>/dev/null || missing=1
    python3 -c "from googleapiclient.discovery import build" 2>/dev/null || missing=1
    if [[ $missing -eq 1 ]]; then
        warn "Google API client libs not installed"
        log "install: pip3 install --user google-auth google-auth-httplib2 google-api-python-client"
        return 1
    fi
    [[ -f "$GSC_KEY_FILE" ]] || { warn "GSC key not found: $GSC_KEY_FILE"; return 1; }
    return 0
}

run_gsc_live() {
    log "mode: live --source=gsc"
    if [[ $DRY_RUN -eq 1 ]]; then
        log "dry-run: would call GSC searchAnalytics.query for last 28 days"
        log "  site: https://heimaeden.com"
        log "  dimensions: query, country, device, page"
        log "  output: overwrite docs/persona-data.json[data_sources.gsc] → [LIVE]"
        log "  prerequisites: google-api-python-client installed + scripts/gsc-key.json exists"
        return 0
    fi
    if ! gsc_deps_check; then
        fail "see docs/gsc-setup-guide.md for full setup" 1
    fi
    # Real GSC call (v1.1 — TODO after user completes OAuth setup)
    warn "GSC live mode is implemented in v1.1 — completing service account setup"
    log "follow docs/gsc-setup-guide.md (Section 1-6) then re-run"
    exit 3
}

run_cf_analytics_live() {
    fail "CF Analytics source is not yet implemented (planned v1.2)" 3
}

run_reddit_live() {
    fail "reddit/hn/github source is not yet implemented (planned v1.3)" 3
}

run_plausible_live() {
    fail "Plausible source is not yet implemented (planned v1.4)" 3
}

run_live() {
    require_cache
    case "$SOURCE" in
        gsc)
            run_gsc_live
            ;;
        cf_analytics)
            run_cf_analytics_live
            ;;
        reddit_hn_github)
            run_reddit_live
            ;;
        plausible)
            run_plausible_live
            ;;
        all)
            log "source=all: running wired sources in sequence"
            run_gsc_live || warn "gsc skipped"
            warn "cf_analytics: not implemented (v1.2)"
            warn "reddit_hn_github: not implemented (v1.3)"
            warn "plausible: not implemented (v1.4)"
            ok "live mode complete (only GSC reached)"
            ;;
        *)
            fail "unknown --source: $SOURCE (use: gsc, cf_analytics, reddit_hn_github, plausible, all)" 1
            ;;
    esac
}

# ---- dispatch --------------------------------------------------------------
case "$MODE" in
    default) run_default ;;
    check)   run_check ;;
    live)    run_live ;;
    *)       fail "internal: invalid mode $MODE" 1 ;;
esac
