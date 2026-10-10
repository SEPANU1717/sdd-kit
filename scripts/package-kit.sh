#!/usr/bin/env sh
# Builds release zips from the committed HEAD (uncommitted changes are not included).
# 1. dist/sdd-kit-<version>.zip: the whole kit, ready to unzip into a project root.
# 2. dist/skills/<skill>-<version>.zip: one zip per skill with SKILL.md and LICENSE at
#    the root, for marketplaces that take single skills. The sdd-* skills read the
#    kit's .agents/rules, templates and schemas, so they need the full kit installed.
# Usage: sh scripts/package-kit.sh
set -eu
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
[ -f LICENSE ] || { echo "LICENSE is missing" >&2; exit 1; }
git ls-files --error-unmatch LICENSE >/dev/null 2>&1 || { echo "commit LICENSE first" >&2; exit 1; }
if [ -n "$(git status --porcelain)" ]; then
  echo "warning: uncommitted changes are not packaged" >&2
fi
version="$(git describe --tags --always)"
rm -rf dist
mkdir -p dist/skills

git archive --format=zip --prefix=sdd-kit/ -o "dist/sdd-kit-$version.zip" HEAD \
  AGENTS.md CLAUDE.md LICENSE README.md .agents .claude scripts
echo "built dist/sdd-kit-$version.zip"

for dir in .agents/skills/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  git archive --format=zip --add-file=LICENSE -o "dist/skills/$name-$version.zip" "HEAD:.agents/skills/$name"
  echo "built dist/skills/$name-$version.zip"
done
