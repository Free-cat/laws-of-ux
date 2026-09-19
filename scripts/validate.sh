#!/usr/bin/env bash
# Structural validation for the laws-of-ux plugin.
# Checks manifests, content completeness, and frontmatter.
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
pass() { printf '  PASS  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1"; fail=1; }

MANIFESTS=(
  ".claude-plugin/plugin.json"
  ".cursor-plugin/plugin.json"
  ".codex-plugin/plugin.json"
  "gemini-extension.json"
)

echo "== manifests =="
for m in "${MANIFESTS[@]}"; do
  if [ ! -f "$m" ]; then bad "$m exists"; continue; fi
  if python3 -c "import json,sys; json.load(open('$m'))" 2>/dev/null; then
    pass "$m is valid JSON"
  else
    bad "$m is valid JSON"
  fi
done

if [ "$(ls -1 "${MANIFESTS[@]}" 2>/dev/null | wc -l | tr -d ' ')" = "4" ]; then
  # Paths are passed as argv, not interpolated — keeps this working on the
  # bash 3.2 that ships with macOS (no ${arr[@]@Q}).
  nver=$(python3 -c "
import json, sys
print(len({json.load(open(m))['version'] for m in sys.argv[1:]}))
" "${MANIFESTS[@]}" 2>/dev/null || echo 99)
  [ "$nver" = "1" ] && pass "all manifest versions identical" || bad "all manifest versions identical"
fi

echo "== skill =="
SKILL="skills/ux-laws/SKILL.md"
if [ -f "$SKILL" ]; then
  grep -q '^name: ux-laws$' "$SKILL" && pass "SKILL.md has name" || bad "SKILL.md has name"
  grep -q '^description:' "$SKILL" && pass "SKILL.md has description" || bad "SKILL.md has description"
  for cmd in research critique fix audit; do
    grep -q "\`$cmd " "$SKILL" && pass "SKILL.md documents '$cmd'" || bad "SKILL.md documents '$cmd'"
  done
else
  bad "$SKILL exists"
fi

echo "== reference content =="
LAWS="skills/ux-laws/reference/laws.md"
if [ -f "$LAWS" ]; then
  n=$(grep -c '^### ' "$LAWS")
  [ "$n" = "30" ] && pass "laws.md has 30 entries" || bad "laws.md has 30 entries (found $n)"
  grep -qi 'not.*lawsofux.com' "$LAWS" \
    && pass "laws.md disclaims the grouping" || bad "laws.md disclaims the grouping"
else
  bad "$LAWS exists"
fi

for f in extended-rules rubric research-checklist fix-guardrails \
         researcher-prompt critic-prompt fixer-prompt codex-tools gemini-tools; do
  p="skills/ux-laws/reference/$f.md"
  [ -f "$p" ] && pass "$p exists" || bad "$p exists"
done

echo "== agents =="
for a in ux-researcher ux-critic ux-fixer; do
  p="agents/$a.md"
  if [ -f "$p" ]; then
    grep -q "^name: $a$" "$p" && pass "$p has name" || bad "$p has name"
    grep -q '^tools:' "$p"    && pass "$p has tools allowlist" || bad "$p has tools allowlist"
  else
    bad "$p exists"
  fi
done

# Tool-allowlist gate. A raw grep of the `tools:` line only sees an inline
# flow scalar, so a block sequence or folded scalar slips past; and grepping
# for "Edit" also matches "NotebookEdit". Parse the frontmatter instead and
# match exact tool names.
has_tool() {
  # $1: agent file, $2: tool name. Prints "yes" or "no".
  python3 - "$1" "$2" <<'PYEOF'
import re, sys
path, tool = sys.argv[1], sys.argv[2]
text = open(path).read()
m = re.match(r'\A---\n(.*?)\n---\n', text, re.DOTALL)
if not m:
    print("no"); sys.exit(0)
body = m.group(1)
tools = None
try:
    import yaml
    tools = yaml.safe_load(body).get("tools")
except ImportError:
    # Minimal fallback: inline list, flow list, or block sequence.
    tm = re.search(r'^tools:(.*)$', body, re.MULTILINE)
    if tm:
        rest = tm.group(1).strip()
        if rest.startswith('['):
            tools = [t.strip().strip('\'"') for t in rest.strip('[]').split(',')]
        elif rest:
            tools = [t.strip().strip('\'"') for t in rest.split(',')]
        else:
            seq = []
            for line in body[tm.end():].split('\n'):
                if not line.strip():
                    continue
                if not re.match(r'^\s+-\s', line):
                    break
                seq.append(line.strip().lstrip('-').strip().strip('\'"'))
            tools = seq
items = []
if isinstance(tools, list):
    items = [t for t in tools if isinstance(t, str)]
elif isinstance(tools, str):
    items = tools.split(',')
items = [t.strip().strip('\'"') for t in items]
print("yes" if tool in items else "no")
PYEOF
}

[ "$(has_tool agents/ux-critic.md Edit)" = "no" ] && [ "$(has_tool agents/ux-critic.md Write)" = "no" ] \
  && pass "ux-critic has no Edit/Write" || bad "ux-critic must NOT have Edit/Write"
[ "$(has_tool agents/ux-researcher.md Edit)" = "no" ] && [ "$(has_tool agents/ux-researcher.md Write)" = "no" ] \
  && pass "ux-researcher has no Edit/Write" || bad "ux-researcher must NOT have Edit/Write"
[ "$(has_tool agents/ux-fixer.md Edit)" = "yes" ] \
  && pass "ux-fixer has Edit" || bad "ux-fixer has Edit"

echo "== placeholders =="
if grep -rnE '\b(TBD|TODO|FIXME|fill in later)\b' \
     skills agents README.md 2>/dev/null | grep -v '^Binary'; then
  bad "no placeholder markers in shipped content"
else
  pass "no placeholder markers in shipped content"
fi

echo
[ "$fail" = "0" ] && echo "ALL CHECKS PASSED" || echo "SOME CHECKS FAILED"
exit "$fail"
