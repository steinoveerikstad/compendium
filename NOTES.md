# NOTES.md — running log

Most recent entry at the top.

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
