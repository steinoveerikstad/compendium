# TODO — TMR4115 compendium

Working list. Done items move to `CHANGELOG.md` under the version that shipped
them; `NOTES.md` keeps the per-session narrative. Rough order of priority
within each section.

## Chapters to write

- [ ] **Ship size and speed** (`ch_ship_size_speed.tex`) — content exists as
      `v2025115.pdf`, needs converting to LaTeX. Would become chapter 1, ahead
      of linear programming
- [ ] **Configuration** (`ch_configuration.tex`) — stub only
- [ ] **Nonlinear programming** (`ch_nlp.tex`) — stub only
- [ ] **Decisions under uncertainty** (`ch_uncertainty.tex`) — stub only. Three
      written chapters already forward-reference it, so it is the most-promised
      of the four

## Editorial

- [ ] Overfull hboxes: 59 at last count across the three written chapters. Only
      the facility location chapter ever had a line-by-line pass, and it has
      changed twice since. Redo for all three
- [ ] Typos in the merged Agersborg prose in `ch_facility_location.tex`:
      `(again according to ) \citet{...}` has a stray empty parenthesis, and
      `inpection` in the offshore charging section intro
- [ ] `ch_integer_programming.tex` opens with "The previous chapter treated every
      decision variable as continuous", which dangles when the chapter is read
      as a standalone lecture note. Reword to name linear programming instead,
      and grep the other chapters for the same phrasing
- [ ] Decide whether the facility location chapter still reads as a whole after
      the offshore-charging consolidation in 0.4.0 — the Agersborg material is
      now the only treatment, and it was written as a thesis chapter

## Housekeeping

- [ ] Figure filenames in `fig/ch_facility_location/` still carry the thesis-era
      `fig4_` prefix, now meaningless. Renaming is optional churn — decide once
      rather than revisiting
- [ ] `fueleu_step_costs.png` sits in `fig/ch_integer_programming/` but is not
      referenced anywhere. Either use it in the FuelEU discussion or drop it
- [ ] `gh` CLI is not installed, so GitHub releases have to be created through
      the web UI. `brew install gh` if that gets tedious

## Ideas, not committed

- [ ] Exercises at the end of each chapter, with solutions in an appendix built
      only in compendium mode
- [ ] Port the Xpress listings to Gurobi, or at least expand the porting notes
- [ ] An index — would need `makeidx`, so weigh against the few-packages rule
