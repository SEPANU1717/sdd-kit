#!/usr/bin/env sh
set -eu
ROOT=${1:-.}
ROOT=$(CDPATH= cd -- "$ROOT" && pwd)
ALLOW_PROJECT_TEMPLATE=${2:-}
failures=0
warnings=0
fail() { printf 'FAIL: %s\n' "$1"; failures=$((failures + 1)); }
warn() { printf 'WARN: %s\n' "$1"; warnings=$((warnings + 1)); }
require_file() { [ -f "$ROOT/$1" ] || fail "missing file: $1"; }
printf 'SDD doctor (POSIX): %s\n' "$ROOT"
for file in AGENTS.md README.md .agents/rules/project.md .agents/rules/sdd-workflow.md .agents/rules/writing-specs.md .agents/skills/INDEX.md; do require_file "$file"; done
project="$ROOT/.agents/rules/project.md"
if [ "$ALLOW_PROJECT_TEMPLATE" != '--allow-project-template' ] && grep -Eq '<project name>|<one or two sentences>|<prototype \| beta \| production>|<e\.g\.|<folder>|<!--' "$project"; then
  fail 'project.md still contains template placeholders'
fi
if command -v git >/dev/null 2>&1; then
  if [ ! -d "$ROOT/.git" ]; then warn 'no .git directory; baseline and diff checks are unavailable'; fi
else
  warn 'git executable unavailable; baseline and diff checks are unverified'
fi
for spec in "$ROOT"/.agents/features/*/spec.md; do
  [ -f "$spec" ] || continue
  feature=$(basename "$(dirname "$spec")")
  case "$feature" in ????????-*) : ;; *) fail "feature $feature: invalid feature id" ;; esac
  grep -Eq '^- Revision: [0-9]+$' "$spec" || warn "feature $feature: legacy spec has no Revision field"
  acs=$(sed -n 's/^- AC\([0-9][0-9]*\):.*/AC\1/p' "$spec")
  for ac in $acs; do
    count=0
    for plan in "$(dirname "$spec")"/plan-*.md; do
      [ -f "$plan" ] || continue
      if grep -Eq "^- Spec: .*\b$ac\b" "$plan"; then count=$((count + 1)); fi
    done
    [ "$count" -eq 1 ] || fail "feature $feature: $ac is covered by $count plans; expected exactly one"
  done
done
for skill in "$ROOT"/.agents/skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  name=$(basename "$(dirname "$skill")")
  mirror="$ROOT/.claude/skills/$name/SKILL.md"
  if [ ! -f "$mirror" ]; then fail "skill mirror missing: $name"
  elif command -v sha256sum >/dev/null 2>&1; then
    [ "$(sha256sum "$skill" | awk '{print $1}')" = "$(sha256sum "$mirror" | awk '{print $1}')" ] || fail "skill mirror drift: $name"
  elif command -v shasum >/dev/null 2>&1; then
    [ "$(shasum -a 256 "$skill" | awk '{print $1}')" = "$(shasum -a 256 "$mirror" | awk '{print $1}')" ] || fail "skill mirror drift: $name"
  else
    warn "cannot hash skill mirror: $name"
  fi
done
printf 'Result: %s failure(s), %s warning(s)\n' "$failures" "$warnings"
[ "$failures" -eq 0 ] || exit 1
