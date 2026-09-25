# Changelog

All notable changes to the TMR4115 Design Methods compendium.

Versioning is semver-lite:

| Part | Bumped when |
|------|-------------|
| MAJOR | a new taught edition of the course (`1.0.0` = first delivery) |
| MINOR | a chapter is added, or an existing one substantially rewritten |
| PATCH | fixes, typos, layout passes, small additions |

Every released version is a git tag (`v0.4.0`) with a GitHub release carrying
the built `main.pdf`. Run `./release.sh <version>` to cut one.

---

## [Unreleased]

### Added
- `README.md`: how to build both modes, and the four-step release procedure.
  It is the human-facing entry point; `CLAUDE.md` now points at it rather than
  restating the steps

## [0.4.0] — 2026-09-25

### Added
- Two build modes in `main.tex`. `\CompendiumMode` = 1 builds the full
  compendium (`book`, title page, table of contents, numbered chapters);
  `\CompendiumMode` = 0 builds a single chapter as a standalone lecture note
  (`article`, plain title and date, sections numbered from 1). `\NoteChapter`
  selects the chapter. Chapter files are unchanged in either mode: `\chapter`
  is redefined in note mode so the chapter heading becomes the note title
- Title page for the compendium, showing version and date. There was none before
- `\CompendiumVersion` and `\CompendiumDate`, printed on the title page and on
  every lecture note, so any printed copy identifies its edition
- This changelog, `TODO.md`, and `release.sh`

### Changed
- Cross-chapter references now name the idea rather than a section number, so a
  chapter reads correctly both in the compendium and as a standalone note. The
  three in `ch_integer_programming.tex` were reworded; convention recorded in
  `CLAUDE.md`
- `ch_facility_location.tex`: the compendium's own treatment of offshore
  charging (`One vessel, one station`, `A fleet sharing one station`, `A fleet
  with several stations`, `The integrated arc-based formulation`) was removed in
  favour of the Agersborg material, which covered the same ground. The
  value-of-network figure was kept and given a short lead-in

### Fixed
- Three `??` references when `ch_integer_programming.tex` is built as a note
- Dangling reference to the value-of-network figure left by the section removal

## [0.3.0] — 2026-09-24

Initial commit. State after the structure and preamble cleanup.

### Added
- Three written chapters: linear programming, integer programming, facility
  location and network design
- Single-preamble layout, `fig/<chapter>/` bitmap figures, one shared
  `compendium.bib`, Python listings in `code/`

### Changed
- Preamble cut from 16 packages to 11: dropped `subcaption`, `mathtools`,
  `enumitem`, `inputenc`, `courier`, `ifthen` and the explicit `xcolor`
- `facility_location.tex` (two concatenated documents) merged into a single
  chapter and renamed `ch_facility_location.tex`
- `chapter_shell.tex` deleted; it held a third copy of the preamble

[Unreleased]: https://github.com/steinoveerikstad/compendium/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/steinoveerikstad/compendium/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/steinoveerikstad/compendium/releases/tag/v0.3.0
