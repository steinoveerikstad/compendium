#!/usr/bin/env bash
#
# release.sh — cut a versioned release of the compendium.
#
#   ./release.sh 0.5.0
#
# Bumps \CompendiumVersion and \CompendiumDate in main.tex, rebuilds, refuses to
# continue on a LaTeX error or an undefined reference, then commits, tags and
# pushes. Attaching main.pdf to the GitHub release is the one manual step; the
# script prints the link at the end.
#
# Run it on a clean working tree, with the CHANGELOG entry for this version
# already written.

set -euo pipefail
cd "$(dirname "$0")"

VERSION="${1:-}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: ./release.sh <major.minor.patch>    e.g. ./release.sh 0.5.0" >&2
  exit 1
fi
TAG="v$VERSION"

# --- preconditions ---------------------------------------------------
[[ "$(git branch --show-current)" == "main" ]] \
  || { echo "error: not on main" >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] \
  || { echo "error: working tree is dirty — commit or stash first" >&2
       git status --short >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "error: tag $TAG already exists" >&2; exit 1; } || true
grep -q "^## \[$VERSION\]" CHANGELOG.md \
  || { echo "error: no '## [$VERSION]' section in CHANGELOG.md" >&2; exit 1; }

# --- stamp the version -----------------------------------------------
TODAY="$(date +'%e %B %Y' | sed 's/^ *//')"
perl -pi -e "s/\\\\providecommand\{\\\\CompendiumVersion\}\{[^}]*\}/\\\\providecommand{\\\\CompendiumVersion}{$VERSION}/" main.tex
perl -pi -e "s/\\\\providecommand\{\\\\CompendiumDate\}\{[^}]*\}/\\\\providecommand{\\\\CompendiumDate}{$TODAY}/" main.tex
echo "stamped $TAG ($TODAY) into main.tex"

# --- build and verify ------------------------------------------------
echo "building..."
latexmk -pdf -outdir=build -interaction=nonstopmode main.tex >/dev/null 2>&1 || true
ERRORS=$(grep -c '^!' build/main.log || true)
UNDEF=$(grep -c 'undefined' build/main.log || true)
[[ -f build/main.pdf ]] || { echo "error: no PDF produced" >&2; exit 1; }
[[ "$ERRORS" -eq 0 ]] || { echo "error: $ERRORS LaTeX error(s), see build/main.log" >&2; exit 1; }
[[ "$UNDEF"  -eq 0 ]] || { echo "error: undefined references, see build/main.log" >&2
                           grep -i 'undefined' build/main.log >&2; exit 1; }
PAGES=$(pdfinfo build/main.pdf | awk '/^Pages/{print $2}')
echo "build clean: $PAGES pages, no errors, no undefined references"

# --- commit, tag, push -----------------------------------------------
git add main.tex CHANGELOG.md
if git diff --cached --quiet; then
  echo "version already stamped and committed; tagging HEAD as is"
else
  git commit -m "Release $TAG"
fi
git tag -a "$TAG" -m "$TAG"
git push origin main
git push origin "$TAG"

cp build/main.pdf "build/TMR4115-compendium-$TAG.pdf"

cat <<MSG

$TAG pushed.

Last step, attach the PDF to the release:
  https://github.com/steinoveerikstad/compendium/releases/new?tag=$TAG
  upload  build/TMR4115-compendium-$TAG.pdf
  body    the [$VERSION] section of CHANGELOG.md

With the gh CLI installed this becomes one command:
  gh release create $TAG build/TMR4115-compendium-$TAG.pdf --title "$TAG" --notes-file -
MSG
