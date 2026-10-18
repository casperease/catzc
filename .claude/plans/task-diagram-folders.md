---
task:
  status: open
  plans: [plan-diagram-folders]
  value: high
  blocked_on: step 3 onward on the user's approval of the out/ pilot (task-decision-round); steps 1 and 2 can start now
  targets:
    [
      docs/explanation,
      .claude/drawio,
      pwsh/Catzc.Base.Slides,
      pwsh/Catzc.Base.Globs/configs/file-kinds.yml,
      docs/adr/repository/conventional-folders.md,
      docs/adr/repository/slides-as-markdown.md,
    ]
---

# Task: every diagram one folder beside its article, rebuilt by one command on that folder

The kit is done (drawio_forward.py and drawio.yml hold the subtitle and lens rules) and the out/ pilot rendered clean on 2026-10-18
(exit 0, 10 of 10 joined). What is left is the kit tests, the pilot's approval, the move command, the migration of all 150 diagrams one
article folder at a time, `Build-Diagrams -Path`, the ADR restatements and the emptied folders. Until the migration lands, the kit cannot
rebuild the flat `docs/explanation/.assets` slides, so no slide is rendered before step 6. Diagram cells are never edited here; a diagram
change is `write-drawio-files`.

## Steps

1. Kit tests: subtitle parsing (both code forms reported, the canonical accepted), the closed lens set, the `Supports (<lens> lens)` drift
   warning, under the test home the decision round names (`.claude/drawio/tests/`) and run with `uv run` under the time safeguard. Check:
   the tests pass; `Test-FileMeta` clean on the new files.
2. The two subtitles still in the `:1,2,3` form (`adr-dsgn-aspect--each-track-picks-its-catch-all--meta`,
   `adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta`) normalised through `write-drawio-files`. Check: the subtitle parser
   reports none; the two rasters re-rendered from their models.
3. The move command in `pwsh/Catzc.Base.Slides` (`Move-Diagram`): `git mv` of one diagram folder, every relative link in the moved `.md`
   files and in the pages that link into them resolved to its repository path and recomputed from the new place; `-DryRun` lists; L0
   tests on neutral widget/gadget fixtures under TestDrive with a fixture git repository. Check: its test file passes; `Test-Links` clean
   after a fixture move.
4. `Build-Diagrams -Path <folder>`: rebuild one diagram folder; no path repeats that for every diagram folder found under
   `docs/**/.assets/**`; `diagram_folders` in `pwsh/Catzc.Base.Slides/configs` goes in the same change (ADR-PRIN-ONELIVE). L0: one
   folder, every folder, an orphan reported, two embedders fail, the locality gate. Check: `Build-Diagrams.Tests.ps1` passes; a dry run
   lists the call set per folder. `SlidesConfig` tests follow the key removal.
5. ADR-REPO-FOLDERS (conventional-folders.md, the `.assets` paragraph), ADR-REPO-SLIDES#7 (slides-as-markdown.md) and `file-kinds.yml`
   (the diagram kinds select `docs/**/.assets/**`) restated, present tense. Check: `Test-AdrRegistry`, `Test-Links`, the file-kind
   reachability test clean; `Build-AdrIndex` dry run unchanged or applied.
6. Migration, one article folder at a time through the move command, `docs/explanation/configuration` first (the pilot's source): each
   diagram's nine files assembled under `<article-folder>/.assets/<name>/` with role names, the description inside, then
   `Build-Diagrams -Path` on each new folder. Check: `Test-Links`, `Test-FileMeta`, `Test-Spelling` clean on the folder before the next;
   the article folders done are listed in the plan as they land.
7. `glyphs.drawio.png` and `glyphs.drawio.md` into `docs/explanation/.assets/glyphs/` under role names. Check: every page that links it
   resolves (`Test-Links` over docs/explanation).
8. Delete the emptied `docs/explanation/.assets/{grid,tree,chain}/`; `Build-Diagrams.ps1.md` help and `catzc-base-slides.md`
   responsibility:4 follow the parameter. Check: `git ls-files docs/explanation/.assets` lists only `glyphs/`; `Test-Links` on the two
   edited pages; the final full run is the tree-wide proof.
9. Tick the plan's steps as each lands; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero in plan-diagram-folders.

## Report

As report-fixed; the migration step reports the article folders done and the ones left.
