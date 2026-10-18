---
plan:
  status: blocked
  value: high
  reviewed: 2026-10-18
  blocked_on: nothing; the pilot and the kit test home were decided 2026-10-18, the kit tests landed
  targets: [docs/explanation, .claude/drawio, pwsh/Catzc.Base.Slides, pwsh/Catzc.Base.Globs, docs/adr/repository]
---

# Every diagram is one folder beside its article, rebuilt by one command on that folder

A diagram is a folder `<article-folder>/.assets/<name>/` holding everything the diagram owns, under role names: `diagram.drawio.png`, its
description `diagram.drawio.md`, and `grid`, `tree` and `chain` each as a `.png` and a `.md`. Moving the diagram moves the folder.
`Build-Diagrams -Path <folder>` rebuilds one folder in place; with no path it repeats that for every diagram folder (ADR-REPO-SLIDES#7). The
explanation article stays outside the folder; the render reads it and never writes it. Scope: the 150 slides of `docs/explanation`; the 18
in `docs/.assets` and `docs/references/.assets` follow later.

## Why its value is high

A diagram's nine files sit in five places under two names today (the article stem and `adr-<code>--<title>--<lens>`), so no diagram can be
moved, reviewed or rebuilt as one thing. One folder per diagram makes the move a single `git mv` plus one fixed embed line.

## Decisions

Recorded 2026-10-18 with the user:

- Role names inside the folder; the folder name is the diagram's only name.
- The description moves into the folder. Its relative links (ADR-REPO-LINK#2) are kept right by a move command, not generated: one tested
  command moves a diagram folder with `git mv` and re-points every relative link in the moved `.md` files and in the pages that link into
  them, each resolved to its repository path and recomputed from the new place; Test-Links after each move.
- ADR codes and lens come from the model's `subtitle` cell only (`<codes> · <lens>`, on all 151 models); the sidebar chips, the lens badge
  and the page name are outputs. The lens is a closed set of six in `drawio.yml` (today `LENS_BADGE` in render.py); a lens outside it fails
  the render. The article's `Supports … (<lens> lens)` line is checked against the subtitle and warns on drift, never parsed as the source.
- A folder finds its article among the pages of the folder that holds its `.assets`: the one page that embeds its `diagram.drawio.png`. None
  is an orphan, reported with every other artifact delivered; two fail. Locality is the search space, so a folder moved away from its
  article is reported as an orphan.
- The render reads the article for its title (minimap links), its text (`--assert`) and the `Supports` line check.
- The pilot runs in `out/` only: a copy of `docs/explanation/configuration/` in the new layout, rendered by the new kit, for the user's
  review. Nothing in `docs/` moves until the user approves; then all 150 move in one change, so the kit only ever supports one layout in the
  tree (ADR-PRIN-ONELIVE).

## Needed docs

- ADR-REPO-FOLDERS (conventional-folders.md, the `.assets` paragraph) restated: `.assets/` beside an article holds one folder per diagram,
  the role names, and the description inside the folder.
- ADR-REPO-SLIDES#7 restated: one command on one folder; the whole tree is that command repeated.
- `file-kinds.yml` diagram kinds move from the three fixed `.assets` roots to `docs/**/.assets/**`.
- `Build-Diagrams.ps1.md` help and `catzc-base-slides.md` responsibility:4 follow the new parameter.

## Needed tests

- `Build-Diagrams` L0: one folder, every folder, orphan, two embedders, the locality gate (neutral widget/gadget fixtures).
- `SlidesConfig` L0 for whatever replaces `diagram_folders` (a diagram folder is found, not listed).
- Kit: subtitle parsing (both code forms reported, the canonical one accepted), the lens set, the `Supports` drift warning.
- Test-Links, Test-FileMeta and Test-Spelling clean on every moved folder.

## Open steps

- [x] Kit, one layout: `drawio_forward.py --all <root>` finds every diagram folder under the root (a folder itself when it is one); codes
      and lens from the `subtitle` cell, the lens set in `drawio.yml`; `render.py`, `join.py` and `describe.py` write beside each slide
      under role names; `describe.py` finds the article by locality; `stamp.ps1` stamps each folder's pages from the slide list; the
      file-name code and lens go (check: the out/ pilot below renders clean). Done 2026-10-18: also fixed the highlight stage, which ignored
      its slice; W_SUBTITLE and W_SUPPORTS warnings; spelling, file-meta, comments and analyzer gates clean. Until the migration step,
      `Build-Diagrams` and the kit cannot rebuild the flat `docs/explanation/.assets` slides; render none until then.
- [x] Done 2026-10-18 (catzc-93; verdict in task-diagram-folders step 1). Kit tests: subtitle parsing, the lens set and the `Supports` drift, as Needed tests lists (check: the tests pass).
- [x] Pilot in out/: `out/diagram-pilot/` holds `configuration/` in the new layout (articles copied, each diagram assembled into its
      folder), rendered by the new kit (check: exit 0; the user compares the slides with today's and approves). Rendered 2026-10-18 by
      `out/diagram-pilot.py`: exit 0, 10 of 10 joined; each slide matches today's apart from the minimaps, which follow the current maps
      (`out/diagram-pilot/sidebar-old-vs-new.png`). Approved by the user 2026-10-18; the row still labelled `automation` in both
      sidebars is fixed when the minimaps re-render in the new layout (describe.py already says `pwsh/`).
- [x] Normalise the two subtitles still in the `:1,2,3` form (adr-dsgn-aspect--each-track-picks-its-catch-all--meta,
      adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta) through write-drawio-files (check: the subtitle parser reports none).
      Closed 2026-10-18 by session catzc-f3 with nothing to change: both are already canonical (`ADR-DSGN-ASPECT#{1-3} · meta`,
      `ADR-AUTO-GO#1 · ADR-PRIN-ONELIVE#{1,5} · meta`, last touched in 928c51e9d); drawio_forward.py on both: exit 0, status ok, no
      W_SUBTITLE.
- [x] Done 2026-10-18 (catzc-fb; verdict in task-diagram-folders step 3). The move command: moves files with `git mv` and re-points relative links in and into them, with L0 tests on neutral fixtures (check:
      its tests pass; Test-Links clean after a fixture move).
- [x] Done 2026-10-18 (catzc-fb, all 149 plus glyphs; verdicts in task-diagram-folders step 6). On approval, all 150 diagrams move, one folder of articles at a time, through the move command (check: Test-Links clean after each
      folder).
- [x] Done 2026-10-18 (catzc-fb; verdict in task-diagram-folders step 4). `Build-Diagrams -Path`, the folder discovery; `diagram_folders` replaced in the same change (ADR-PRIN-ONELIVE); each description's
      rebuild step names `Build-Diagrams -Path` (check: its L0 tests pass, dry run lists the call set per folder).
- [x] Done 2026-10-18 (catzc-fb; verdict in task-diagram-folders step 5). ADR-REPO-FOLDERS, ADR-REPO-SLIDES#7 and `file-kinds.yml` restated (check: Test-AdrRegistry, Test-Links, the file-kind reachability
      test).
- [x] Done 2026-10-18 (catzc-fb; verdict in task-diagram-folders step 7). `glyphs.drawio.png`, the shared glyph legend, into `docs/explanation/.assets/glyphs/` (check: every page that links it resolves).
- [x] Folders done 2026-10-18 (task-diagram-folders step 8); the plan itself goes in the closing sweep. Delete the emptied
      `docs/explanation/.assets/{grid,tree,chain}/` and this plan (check: `git ls-files docs/explanation/.assets` lists
      only `glyphs/`; Test-Plans clean).
