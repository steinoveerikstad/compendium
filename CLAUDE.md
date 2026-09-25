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
├── README.md                   ← how to build and how to release
├── CLAUDE.md                   ← this file
├── NOTES.md                    ← running log, one entry per session
├── CHANGELOG.md                ← what changed in each released version
├── TODO.md                     ← working list of what is still to do
├── release.sh                  ← bump version, build, commit, tag, push
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
chapter file — `main.tex` can already build a single chapter on its own, see
**Two build modes** below.

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

Current build: 70 pages, no errors, no undefined references or citations.

## Code listings

Python examples use Xpress (`xpress` package) as the primary solver.
Porting notes for Gurobi go in prose where the API differs.
Data files live in `code/` alongside the script.

## Building

### Two build modes

`main.tex` builds either the whole compendium or one chapter as a standalone
lecture note. Two switches at the top of the file control this:

```latex
\providecommand{\CompendiumMode}{1}          % 1 = compendium, 0 = lecture note
\providecommand{\NoteChapter}{ch_facility_location}   % which chapter, in note mode
```

| | `\CompendiumMode` = 1 | `\CompendiumMode` = 0 |
|---|---|---|
| class | `book` | `article` |
| front | title page + table of contents | title, author, date only |
| chapters | all `\include`d ones | just `\NoteChapter`, via `\input` |
| headings | `\chapter` numbered, sections 3.1, 3.2 | `\chapter` becomes the note title, sections 1, 2 |

The switch is implemented by a conditional `\documentclass` and one conditional
block in the preamble and in the body. Chapter files need no change: `\chapter`
is redefined in note mode so the same file works in both.

```
# whole compendium
latexmk -pdf -outdir=build -interaction=nonstopmode main.tex

# one chapter as a lecture note, without editing main.tex
latexmk -pdf -outdir=build -jobname=note_lp -interaction=nonstopmode \
  -usepretex='\def\CompendiumMode{0}\def\NoteChapter{ch_lp_types}' main.tex
```

Editing the two `\providecommand` values instead works the same way (that is what
`\providecommand` is for — the command line wins if set), but the output is then
still `build/main.pdf`, so pass `-jobname` when a note should not overwrite the
compendium PDF.

Note mode leaves cross-chapter `\ref`s undefined, since the other chapters are
not typeset. There are currently none: when a chapter needs to point at material
in another one, name the idea rather than the section number ("the structured
formulation discipline developed for linear programs", not
"Section~\ref{sec:structured-formulation}"). That reads correctly in both modes.
Keep `\ref` for targets inside the same chapter file.

Two TeX installations are present on this machine and the project builds on both:

- TeX Live 2026 at `/usr/local/texlive/2026/bin/universal-darwin` — used by
  VS Code / LaTeX Workshop (see `.vscode/settings.json`), has everything.
- TinyTeX at `~/Library/TinyTeX` — what bare `latexmk` on `$PATH` resolves to.
  `pgf` and `listings` were installed into it; its `tlmgr` needs the frozen 2024
  repository (`https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2024/tlnet-final`).

If a package turns out to be missing, prefer removing the dependency over
installing it.

## Version control and releases

The project is a git repository, on GitHub at
`https://github.com/steinoveerikstad/compendium` (public). Branch `main`.

**Versioning is semver-lite.** MAJOR = a taught edition of the course
(`1.0.0` = first delivery), MINOR = a chapter added or substantially rewritten,
PATCH = fixes, typos and layout passes. The current version lives in `main.tex`:

```latex
\providecommand{\CompendiumVersion}{0.4.0}
\providecommand{\CompendiumDate}{25 September 2026}
```

Both are printed on the compendium title page and in the header of every
lecture note, so any printed copy identifies its edition. `release.sh` rewrites
them — do not bump them by hand.

**The release procedure is in `README.md`**, which is the human-facing entry
point — do not restate the steps here, and update them there. In short: write
the CHANGELOG section, commit, `./release.sh <version>`, attach the PDF to the
GitHub release. Claude does not cut releases unless asked.

**Five files, five jobs.** Keep them apart:

| File | Holds |
|------|-------|
| `README.md` | how to build and how to release — written for a person, not for Claude |
| `CHANGELOG.md` | what changed in each *released version*, user-facing |
| `TODO.md` | what is still to do; items move to CHANGELOG when they ship |
| `NOTES.md` | the per-session narrative — what was tried, what was decided and why |
| `CLAUDE.md` | this file: conventions, structure, policy |

The built PDF is never committed; `build/` stays gitignored and the PDF is
distributed as a GitHub release asset.

## What Claude should do in each session

1. Read NOTES.md first for carry-over from the last session.
2. Work in the chapter files. Touch `main.tex` only to add an `\include` line.
3. Verify numbers and equations before writing them. Build before finishing:
   no LaTeX errors, no undefined references.
4. Update NOTES.md at the end with what was done and what is next, move any
   finished items out of TODO.md, and add anything user-facing to the
   `[Unreleased]` section of CHANGELOG.md.
