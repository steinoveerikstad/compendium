# CLAUDE.md — TMR4115 Design Methods Compendium

Read by Claude at the start of every session in this folder. Describes structure,
conventions and current state so nothing needs re-explaining.

## What this project is

A LaTeX compendium for the redesigned NTNU course TMR4115 Design Methods.
Each chapter covers one major topic, stands alone pedagogically, and shares
style and notation with the rest. Audience: MSc students in marine technology
with a basic calculus and linear algebra background.

## Folder structure

```
compendium/
├── main.tex                    ← the only file with a preamble
├── compendium.bib              ← single bibliography for all chapters
├── CLAUDE.md                   ← this file
├── NOTES.md                    ← running log of decisions and to-dos
│
├── ch_ship_size_speed.tex      ← stub
├── ch_configuration.tex        ← stub
├── ch_lp_types.tex             ← written
├── ch_integer_programming.tex  ← written
├── ch_nlp.tex                  ← stub
├── ch_uncertainty.tex          ← stub
├── ch_facility_location.tex    ← written
│
├── fig/                        ← one subfolder per chapter, named after the .tex file
│   ├── ch_integer_programming/
│   ├── ch_facility_location/
│   └── _source/                ← vector originals kept for regeneration only
│
├── code/                       ← Python scripts and data files used in listings
└── build/                      ← LaTeX output (gitignored)
```

## Rules

**One preamble.** `main.tex` is the only file that may contain `\documentclass`
or `\usepackage`. Chapter files start at `\chapter{}` and contain nothing above it.
Never add a preamble, a compile guard, or a standalone-document wrapper to a
chapter file — if a chapter needs to be previewed alone, comment out the other
`\include` lines in `main.tex` instead.

**Few packages.** The full list, and the whole preamble policy:

```
fontenc, lmodern, amsmath, amssymb, booktabs, graphicx, float,
tikz (+arrows.meta, positioning), listings, natbib, hyperref
```

Do not add a package without a concrete need that cannot be met with what is
already loaded. Things deliberately *not* used, and what to do instead:

| Not used     | Use instead                                              |
|--------------|----------------------------------------------------------|
| `subcaption` | two `minipage`s with `\par\smallskip{\small (a) ...}`     |
| `mathtools`  | `\underbrace` from amsmath                                |
| `enumitem`   | plain `enumerate`                                         |
| `courier`    | the global `\ttfamily` set in `\lstset`                   |
| `xcolor`     | already pulled in by tikz; do not load it separately      |
| `inputenc`   | unnecessary, UTF-8 is the pdflatex default                |

**Figures are bitmaps.** PNG, placed in `fig/<chapter-file-name>/` and referenced
with the folder but no `fig/` prefix, since `\graphicspath{{fig/}}` is set:

```latex
\includegraphics[width=0.8\textwidth]{ch_facility_location/fl_hub_solutions.png}
```

Convert vector sources at 300 dpi (`pdftoppm -png -r 300 in.pdf out`) and keep
the original in `fig/_source/`. TikZ stays as source for diagrams drawn inline
in the text — those are not figures in this sense.

**Labels.** `\label{sec:<ch>-<name>}`, e.g. `\label{sec:fl-networks}`. Figures
and tables use `fig:` and `tab:` with the same chapter prefix.

**Bibliography.** All entries go in `compendium.bib`. No per-chapter `.bib` files.

## Chapter status

| File | Status | In main.tex |
|------|--------|-------------|
| ch_ship_size_speed.tex | stub — content exists as PDF (v2025115.pdf), needs LaTeX | no |
| ch_configuration.tex | stub | no |
| ch_lp_types.tex | written | yes (ch. 1) |
| ch_integer_programming.tex | written | yes (ch. 2) |
| ch_nlp.tex | stub | no |
| ch_uncertainty.tex | stub | no |
| ch_facility_location.tex | written | yes (ch. 3) |

Current build: 68 pages, no errors, no undefined references or citations.

## Code listings

Python examples use Xpress (`xpress` package) as the primary solver.
Porting notes for Gurobi go in prose where the API differs.
Data files live in `code/` alongside the script.

## Building

```
latexmk -pdf -outdir=build -interaction=nonstopmode main.tex
```

Two TeX installations are present on this machine and the project builds on both:

- TeX Live 2026 at `/usr/local/texlive/2026/bin/universal-darwin` — used by
  VS Code / LaTeX Workshop (see `.vscode/settings.json`), has everything.
- TinyTeX at `~/Library/TinyTeX` — what bare `latexmk` on `$PATH` resolves to.
  `pgf` and `listings` were installed into it; its `tlmgr` needs the frozen 2024
  repository (`https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2024/tlnet-final`).

If a package turns out to be missing, prefer removing the dependency over
installing it.

## What Claude should do in each session

1. Read NOTES.md first for carry-over from the last session.
2. Work in the chapter files. Touch `main.tex` only to add an `\include` line.
3. Verify numbers and equations before writing them. Build before finishing:
   no LaTeX errors, no undefined references.
4. Update NOTES.md at the end with what was done and what is next.
