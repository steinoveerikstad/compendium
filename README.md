# TMR4115 Design Methods — Compendium

LaTeX source for the compendium used in **TMR4115 Design Methods**, MSc in
Marine Technology, NTNU. Each chapter covers one topic, stands alone
pedagogically, and shares notation and style with the rest.

The built PDF is not in the repository. It is attached to each
[release](https://github.com/steinoveerikstad/compendium/releases).

---

## Building

One file, `main.tex`, builds **either** the whole compendium **or** a single
chapter as a standalone lecture note.

### The whole compendium

```
latexmk -pdf -outdir=build -interaction=nonstopmode main.tex
```

Or in VS Code: the default build task, or just save a file — LaTeX Workshop is
set to build on save. Output is `build/main.pdf`.

### One chapter as a lecture note

Two switches at the top of `main.tex` control this:

```latex
\providecommand{\CompendiumMode}{1}                    % 1 = compendium, 0 = lecture note
\providecommand{\NoteChapter}{ch_facility_location}    % which chapter, in note mode
```

Set `\CompendiumMode` to `0`, point `\NoteChapter` at the chapter you want, and
build as usual. Or leave the file alone and override on the command line, which
is the better habit because it keeps the two PDFs apart:

```
latexmk -pdf -outdir=build -jobname=note_lp -interaction=nonstopmode \
  -usepretex='\def\CompendiumMode{0}\def\NoteChapter{ch_lp_types}' main.tex
```

|  | `\CompendiumMode` = 1 | `\CompendiumMode` = 0 |
|---|---|---|
| class | `book` | `article` |
| front | title page + table of contents | title, author, date |
| chapters | all of them | just `\NoteChapter` |
| numbering | chapters numbered, sections 3.1, 3.2 | chapter title becomes the note title, sections 1, 2 |

Chapter files are identical in both modes — `\chapter` is redefined in note mode
so the chapter heading becomes the note's title. Nothing in a chapter file needs
changing, and chapter files never contain a preamble.

> **Careful:** editing `\CompendiumMode` in the file and saving means VS Code's
> build-on-save writes the lecture note to `build/main.pdf`, overwriting the
> compendium. Use the `-usepretex` form with `-jobname` when you want to keep
> both, and remember to set the switch back to `1`.

---

## Cutting a release

The version lives in `main.tex` and is printed on the compendium title page and
in the header of every lecture note, so any printout identifies its edition:

```latex
\providecommand{\CompendiumVersion}{0.4.0}
\providecommand{\CompendiumDate}{25 September 2026}
```

**Do not edit those two lines by hand.** `release.sh` rewrites them.

### The four steps

1. **Write the changelog entry.** Add a `## [0.5.0] — YYYY-MM-DD` section at the
   top of `CHANGELOG.md`, under `Added` / `Changed` / `Fixed`. The script refuses
   to release without it.
2. **Commit everything.** The working tree must be clean and you must be on
   `main`.
3. **Run the script** with the new version number:

   ```
   ./release.sh 0.5.0
   ```

   It stamps the version and today's date into `main.tex`, rebuilds, **aborts if
   there is any LaTeX error or undefined reference**, then commits, tags
   `v0.5.0`, and pushes the commit and the tag. It leaves the PDF ready at
   `build/TMR4115-compendium-v0.5.0.pdf`.
4. **Attach the PDF to the release.** The script prints the link. Open it,
   upload that PDF, and paste the `[0.5.0]` section of `CHANGELOG.md` as the
   release body.

Step 4 is manual only because the GitHub CLI is not installed on this machine.
With `brew install gh` it collapses into the script as a single
`gh release create`.

### Which number to bump

| Part | Bump when |
|------|-----------|
| **MAJOR** | a new taught edition of the course — `1.0.0` is the first delivery |
| **MINOR** | a chapter is added, or an existing one substantially rewritten |
| **PATCH** | fixes, typos, layout passes, small additions |

---

## Where things are written down

| File | Holds |
|------|-------|
| `README.md` | this file — how to build and how to release |
| `CHANGELOG.md` | what changed in each released version |
| `TODO.md` | what is still to do; items move to the changelog when they ship |
| `NOTES.md` | running log, one entry per working session: what was tried and why |
| `CLAUDE.md` | conventions for Claude Code — packages, labels, figures, structure |

---

## Layout

```
main.tex                    the only file with a preamble
compendium.bib              single bibliography for all chapters
release.sh                  bump version, build, commit, tag, push

ch_*.tex                    one file per chapter, starts at \chapter{}
fig/<chapter>/              PNG figures, one folder per chapter file
fig/_source/                vector originals, kept for regeneration only
code/                       Python scripts and data used in the listings
build/                      LaTeX output — gitignored
```

Figures are PNGs referenced without the `fig/` prefix, since
`\graphicspath{{fig/}}` is set:

```latex
\includegraphics[width=0.8\textwidth]{ch_facility_location/fl_hub_solutions.png}
```

## Requirements

A TeX distribution with `pgf`, `listings` and `natbib`. The project builds on
both installations present on the authoring machine:

- **TeX Live 2026** at `/usr/local/texlive/2026/bin/universal-darwin` — what VS
  Code uses, see `.vscode/settings.json`
- **TinyTeX** at `~/Library/TinyTeX` — what a bare `latexmk` on `$PATH` resolves
  to

The preamble is deliberately small (11 packages). Prefer removing a dependency
over installing one.
