# NOTES.md — running log

Most recent entry at the top.

## 2026-09-25 — versioning, changelog, TODO, release process

Goal: get the project onto a versioning scheme with tagged releases, a record of
what changed per version, and a TODO list separate from this log.

**Found on starting:** the repo was already a git repository with one commit
("first commit", f597b0f) and an `origin` at
`https://github.com/steinoveerikstad/compendium` (public), already in sync — so
nothing needed connecting. Uncommitted in the working tree was a 125-line
deletion in `ch_facility_location.tex`, made outside the session: the
compendium's own offshore-charging treatment (`One vessel, one station`,
`A fleet sharing one station`, `A fleet with several stations`,
`The integrated arc-based formulation`) removed in favour of the Agersborg
material. This resolved the duplication item carried since 09-24, but left one
dangling reference and took the build to 64 pages with 1 undefined reference.

**Done:**
- Restored the `fl_charging_network.png` figure (`fig:fl-charging`) with a short
  lead-in paragraph, placed just before `What the model leaves out`. The other
  four deleted subsections stay deleted, per decision in session
- `\CompendiumVersion` and `\CompendiumDate` in `main.tex`, printed on the
  compendium title page and in every lecture note header
- `CHANGELOG.md`, semver-lite: MAJOR = taught edition, MINOR = chapter added or
  rewritten, PATCH = fixes. Seeded with 0.4.0 and a retroactive 0.3.0 for the
  first commit
- `TODO.md`, seeded from the open items that had accumulated here
- `release.sh <version>`: checks branch, clean tree, unused tag and a CHANGELOG
  section; stamps the version; rebuilds; aborts on any LaTeX error or undefined
  reference; commits, tags, pushes; then prints the link for attaching the PDF
  to the GitHub release
- CLAUDE.md: new "Version control and releases" section, and a note on which of
  CHANGELOG / TODO / NOTES holds what

**Decisions:** PDF goes out as a GitHub release asset rather than committed, so
`build/` stays gitignored. Version numbering starts at 0.4.0, reaching 1.0.0 at
the first taught delivery.

**Verified:** compendium builds clean, 64 pages, no errors, no undefined
references; all three lecture notes build clean. Title page and note header
checked in the rendered PDFs. `release.sh` syntax-checked with `bash -n`; its
end-to-end path is exercised by the first real release.

**Open items:** now tracked in TODO.md rather than here.

---

## 2026-09-24 (later) — two build modes in main.tex

Goal: build a single chapter as a standalone lecture note without giving chapter
files their own preamble, while keeping the full compendium build unchanged.

**Done:**
- Added two switches at the top of `main.tex`:
  `\providecommand{\CompendiumMode}{1}` and `\providecommand{\NoteChapter}{...}`.
  `\providecommand` rather than `\newcommand` so `latexmk -usepretex` can override
  them without editing the file
- Mode 1 (compendium): `book`, title page, TOC, all `\include`s, unchanged content
- Mode 0 (lecture note): `article`, `\input` of one chapter, `\chapter` redefined
  to `\title{#1}\maketitle`, so the chapter heading becomes the note title and
  sections number 1, 1.1 instead of 3.1, 3.1.1. Chapter files are untouched
- Conditional `\documentclass` inside `\ifnum ... \else ... \fi`; the flags are
  set before it, which is legal since `\providecommand` comes from the format
- Added a title page to the compendium (there was none): title, author, date.
  Author line is `Stein Ove Erikstad \\ Department of Marine Technology, NTNU`
- Removed stale `build/chapter_shell.*` and `build/texput.*` artefacts left over
  from the deleted `chapter_shell.tex`
- CLAUDE.md: new "Two build modes" section under Building; the "One preamble" rule
  now points there instead of saying to comment out `\include` lines

**Verified:** all four builds exit 0 with no errors. Compendium 70 pages (68 plus
the new title page), no undefined references or citations. Lecture notes:
ch_lp_types 11 pp, ch_integer_programming 21 pp, ch_facility_location 30 pp.
Title pages of both modes checked visually in the rendered PDFs.

- Fixed the 3 cross-chapter references in `ch_integer_programming.tex`, which were
  the only ones in the compendium and printed as `??` in note mode. Each now names
  the idea instead of a section number, so it reads the same in both modes:
  `Section~\ref{sec:lp-assumptions} flagged divisibility as one of four key
  assumptions` became `Divisibility was one of the four defining assumptions of a
  linear program`; `the formulation discipline of
  Section~\ref{sec:structured-formulation}` became `the structured formulation
  discipline developed for linear programs`; `the cargo-mix problem in
  Section~\ref{sec:cargo-mix}` became `the earlier cargo-mix problem`. Convention
  recorded in CLAUDE.md

**Open items (in addition to those below, which all still stand):**
- `ch_integer_programming.tex` opens with "The previous chapter treated every
  decision variable as continuous", which is prose, not a `\ref`, so it builds
  clean but still dangles when the chapter is read as a standalone note. Same for
  any other "the previous chapter" phrasing. Not changed — the author's call
- VS Code may still show a tab for the deleted `chapter_shell.tex`; closing it
  avoids accidentally re-saving the file

---

## 2026-09-24 — project structure and preamble cleanup

Goal: simplify the folder layout, cut LaTeX dependencies, put figures in
per-chapter folders as bitmaps.

**Starting state:** `main.tex` did not compile at all. `facility_location.tex`
(903 lines) was two documents concatenated — the facility location chapter plus a
pasted standalone reconstruction of Agersborg's thesis Chapter 4, complete with
its own `\documentclass`, `\usepackage` block, `\begin{document}`,
`\setcounter{chapter}{3}` and a second `\chapter{}`.

**Done:**
- Merged the pasted block into the chapter: dropped the embedded preamble and the
  `\chapter{Optimization model}` heading, demoted its `\section`/`\subsection`
  one level so it now sits under `\section{When the demand travels...}`
- Renamed `facility_location.tex` → `ch_facility_location.tex`; removed the
  `\ifdefined\CompendiumMode` guard and the duplicated preamble at the top
- Deleted `chapter_shell.tex` (a third copy of the preamble). To preview one
  chapter, comment out the other `\include` lines in `main.tex`
- Removed the `\figurefallback` macro and its three definitions; call sites are
  now plain `\includegraphics`
- Dropped packages: `subcaption` (8 subfigures rewritten as `minipage` pairs with
  manual `(a)`/`(b)` labels), `mathtools` (only `\underbrace` was used),
  `enumitem` (one option), `inputenc`, `courier`, `ifthen`, explicit `xcolor`
  (tikz loads it). Preamble went from 16 packages to 11
- One listing in the facility location chapter hardcoded `\fontfamily{pcr}`,
  which is why Courier was loaded; it now inherits the global `\lstset` style
- Figures moved to `fig/<chapter>/`: `fig/ch_integer_programming/` (3) and
  `fig/ch_facility_location/` (12). All `\includegraphics` paths updated
- `fl_hub_solutions.pdf` and `fl_charging_network.pdf` converted to PNG at
  300 dpi; originals kept in `fig/_source/`
- `fueleu_step_costs.png` was unreferenced; parked in `fig/ch_integer_programming/`
  since that is the chapter that discusses FuelEU
- Deleted the stale `build/` contents (old `chapter_shell` and `facility_location`
  artefacts)
- Installed `pgf` and `listings` into TinyTeX, which was missing both

**Verified:** builds clean on both TeX installations (TinyTeX and TeX Live 2026,
the one VS Code uses). 68 pages, exit 0, no errors, no undefined references,
no undefined citations. All 14 referenced figures load. Spot-checked the rewritten
subfigure pages and the converted bitmaps in the PDF — both render correctly.

**Open items:**
- 59 overfull hboxes across the three written chapters. Only the facility location
  chapter had a line-by-line pass before, and the merge has changed its layout,
  so this needs redoing for all three
- Content duplication in `ch_facility_location.tex`: the Agersborg material
  (`\subsection{Single vessel and single charging station}`, sec. 3.10.1) and the
  compendium's own `\subsection{One vessel, one station}` (sec. 3.10.2) cover the
  same model. This is an editorial call, so it was left alone — decide whether to
  keep both, merge them, or cut one
- Typos spotted in the merged prose, not fixed: "(again according to ) \citet{...}"
  and "inpection" in the offshore charging section intro
- Figure filenames still carry the thesis-era `fig4_` prefix, now meaningless.
  Renaming is optional churn; left as is
- The three citations CLAUDE.md previously listed as undefined (dantzig1963,
  landdoig1960, cho2027) are all present in `compendium.bib` and resolve

---

## 2026-09-21 (later) — LP and integer programming chapters recovered and wired in

A file lp_bip.tex (73 KB) had appeared in the compendium root — not a stub, but the
complete LP and integer programming chapters (previously drafted, per overview.md,
in another session), dropped in as one standalone document with no chapter split
and no \include in main.tex.

**Done:**
- Split into ch_lp_types.tex (Linear programming: formulation and application to ship
  configuration design) and ch_integer_programming.tex (Integer programming: binary
  decisions in fleet renewal and retrofit)
- Stripped fig/ prefix from includegraphics calls (fleet_retrofit_result.png,
  regime_comparison.png) to match main.tex's \graphicspath — both files were already
  correctly placed in fig/ from the earlier folder cleanup
- Wired both into main.tex, ch_lp_types before ch_integer_programming, both before
  ch_facility_location
- Deleted lp_bip.tex (content fully preserved in the two chapter files)
- Compiled main.tex clean: 58 pages, 3 chapters, no LaTeX errors

**Known issues carried over, not fixed in this pass:**
- 3 undefined citations, all pre-existing open items: dantzig1963, landdoig1960,
  cho2027 — none are in compendium.bib yet (see overview.md for what these are)
- ~40 overfull hbox warnings across the two new chapters — not yet reviewed line by
  line (only the facility location chapter has had that pass so far)

---

---

## 2026-09-21 — folder restructured

**Done:**
- Created clean folder structure: main.tex / ch_*.tex / fig/ / code/ / build/
- ch_facility_location.tex extracted from facility_location.tex (preamble stripped, body only)
- Figures moved to fig/: fl_hub_solutions.pdf, fl_charging_network.pdf, fleet_retrofit_result.png, fueleu_step_costs.png, regime_comparison.png
- Code and data moved to code/: flp_xpress.py, distances.csv, hubs.csv, ports.csv
- Build artefacts moved to build/
- compendium.bib created (contains fl_refs.bib entries; merge others as chapters are added)
- main.tex written with preamble and commented-out \include lines for chapters 1–5
- CLAUDE.md and NOTES.md created

**Still to do:**
- Add `.latexmkrc` or VS Code `settings.json` so LaTeX Workshop writes output to build/ (see below)
- Stub out ch_1 through ch_5 as empty files so \include lines can be uncommented
- Chapter 6 has 5 overfull hboxes (up to 123 pt); fix when page geometry is confirmed
- Delete facility_location.tex and fl_refs.bib once confirmed redundant (superseded by ch_facility_location.tex and compendium.bib)
- Decide whether to keep the old facility_location_preview.pdf in build/ or delete it

**VS Code setup for build/ output:**
Add this to `.vscode/settings.json` in the compendium folder:

```json
{
  "latex-workshop.latex.outDir": "build",
  "latex-workshop.latex.recipes": [
    {
      "name": "latexmk",
      "tools": ["latexmk"]
    }
  ],
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": ["-pdf", "-outdir=build", "-interaction=nonstopmode", "-synctex=1", "%DOC%"]
    }
  ]
}
```

**What's in build/ right now:**
facility_location.aux/bbl/blg/fdb_latexmk/fls/log/pdf and facility_location_preview.pdf
These are from the old standalone compile and can be deleted once main.tex compiles cleanly.

---
