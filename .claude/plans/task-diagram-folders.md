---
task:
  status: open
  plans: [plan-diagram-folders]
  value: high
  blocked_on: nothing; the pilot and the kit test home (.claude/drawio/tests/) were decided 2026-10-18
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

The kit is done (drawio_forward.py and drawio.yml hold the subtitle and lens rules) and the out/ pilot rendered clean on 2026-10-18 (exit 0,
10 of 10 joined). What is left is the kit tests, the pilot's approval, the move command, the migration of all 150 diagrams one article
folder at a time, `Build-Diagrams -Path`, the ADR restatements and the emptied folders. Until the migration lands, the kit cannot rebuild
the flat `docs/explanation/.assets` slides, so no slide is rendered before step 6. Diagram cells are never edited here; a diagram change is
`write-drawio-files`.

## Steps

In hand 2026-10-18: session catzc-fb holds steps 3 to 5 (orchestrator). Step 6 has the user's leave (2026-10-18) for Move-Diagram's `git mv`
in the repository, for this migration only; the user still commits.

Step 2 closed 2026-10-18 (catzc-f3: both subtitles already canonical, drawio_forward.py exit 0, no W_SUBTITLE). Step 1 waits on the decision
round's test home for the kit.

1. [x] Landed 2026-10-18 by session catzc-93, verdict: ".claude/drawio/tests/test_slide_facts.py: 16 tests pass under
       `timeout 200 uv run -q --with pillow==12.3.0 --with pytest==9.1.1 python -m pytest .claude/drawio/tests`; Test-FileMeta 0,
       Test-PythonLint 0, Test-PythonTypes 0, Test-Spelling 0 on the new files"; neutral fixtures on a tmp repository, no kit source edited.
       Original step: Kit tests: subtitle parsing (both code forms reported, the canonical accepted), the closed lens set, the
       `Supports (<lens> lens)` drift warning, under the test home the decision round names (`.claude/drawio/tests/`) and run with `uv run`
       under the time safeguard. Check: the tests pass; `Test-FileMeta` clean on the new files.
2. The two subtitles still in the `:1,2,3` form (`adr-dsgn-aspect--each-track-picks-its-catch-all--meta`,
   `adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta`) normalised through `write-drawio-files`. Check: the subtitle parser
   reports none; the two rasters re-rendered from their models.
3. [x] Landed 2026-10-18 by session catzc-fb, verdict: "Move-Diagram.Tests.ps1 Passed (4 cases: folder move with links in and into it plus
       Test-Links clean on the fixture repo after the move, a single-file move under a new name, -DryRun lists and changes nothing, and the
       four refusals); MarkdownLinkRebaser.Tests Passed; COMMENTS 0". It uses a new `MarkdownLinkRebaser.Rebase` overload in Catzc.Base.Docs
       (one link parser); it moves a folder or one file, so step 6 assembles the nine files through it one at a time. Original step: The
       move command in `pwsh/Catzc.Base.Slides` (`Move-Diagram`): `git mv` of one diagram folder, every relative link in the moved `.md`
       files and in the pages that link into them resolved to its repository path and recomputed from the new place; `-DryRun` lists; L0
       tests on neutral widget/gadget fixtures under TestDrive with a fixture git repository. Check: its test file passes; `Test-Links`
       clean after a fixture move.
4. [x] Landed 2026-10-18 by session catzc-fb, verdict: "Build-Diagrams.Tests.ps1 Passed (one folder, every folder, orphan reported and
       rendered, two embedders fail, not-a-diagram-folder refused, dry run lists 3 calls per folder, exit codes); SlidesConfig.Tests Passed;
       the tree dry run lists 0 calls (no diagram folder exists until the migration); LINKS/COMMENTS/MARKDOWNLINT 0 on the Slides pages".
       `diagram_batch` went with `diagram_folders`; step 8's help pages (Build-Diagrams, Move-Diagram, catzc-base-slides responsibility:4)
       already follow. Original step: `Build-Diagrams -Path <folder>`: rebuild one diagram folder; no path repeats that for every diagram
       folder found under `docs/**/.assets/**`; `diagram_folders` in `pwsh/Catzc.Base.Slides/configs` goes in the same change
       (ADR-PRIN-ONELIVE). L0: one folder, every folder, an orphan reported, two embedders fail, the locality gate. Check:
       `Build-Diagrams.Tests.ps1` passes; a dry run lists the call set per folder. `SlidesConfig` tests follow the key removal.
5. [x] Landed 2026-10-18 by session catzc-fb, verdict: "ADRREG issues=0; LINKS 0 and MARKDOWNLINT 0 on conventional-folders.md and
       slides-as-markdown.md; FileKindReachability, Get-FileKind and FileKindsConfig tests Passed; Build-AdrIndex applied, index.md
       unchanged". The two beside-the-article `*.drawio.md` kind patterns stay until step 6 empties them and go in its last change. Original
       step: ADR-REPO-FOLDERS (conventional-folders.md, the `.assets` paragraph), ADR-REPO-SLIDES#7 (slides-as-markdown.md) and
       `file-kinds.yml` (the diagram kinds select `docs/**/.assets/**`) restated, present tense. Check: `Test-AdrRegistry`, `Test-Links`,
       the file-kind reachability test clean; `Build-AdrIndex` dry run unchanged or applied.
6. [x] Landed 2026-10-18, all 149 diagrams. Last verdicts: design "44 folders moved and rendered (132 stages: 126 clean, 6 prepare
       warnings), LINKS 0 / FILEMETA 0 / SPELLING 0 over 223 pages, residue grep 0"; flow "35 folders (105 stages: 102 clean, 3 prepare
       warnings), LINKS/FILEMETA/SPELLING 0 over 176 pages, residue 0"; pipelines "5 folders (15 clean), 0/0/0 over 26 pages, residue 0";
       repository "10 folders (30 clean), 0/0/0 over 51 pages, residue 0". The 9 warnings are W_SUPPORTS (an article's Supports line differs
       from its slide subtitle) and go to the drift and label work. The record as it grew: Session catzc-fb with the user's direct leave for
       `git mv`. Landed: `docs/explanation/configuration` (10 diagrams under `.assets/<article-stem>/` with role names, links re-pointed;
       committed by the user; one folder renders in 13 s through `Build-Diagrams -Path`, all stages clean). Fixes the layout needed:
       `.gitattributes-template` marks `/docs/**/.assets/*/{grid,tree,chain}.md` generated (regenerated by Build-RootConfig);
       `file-carriers.yml` gains a `diagram-folder` sidecar entry. Configuration verdict: "10 diagram folders moved and rendered (30 stages
       clean, 0 orphans); LINKS 0, FILEMETA 0, SPELLING 0 over the 53 pages in and linking into it; git grep 'under `automation/` by module'
       over its .assets: 0". Automation verdict: "30 diagram folders moved and rendered (one W_JOIN on build-then-place-with-one-command, a
       missing palette.json in its work folder, re-rendered clean); LINKS 0, FILEMETA 0, SPELLING 0 over the 152 pages in and linking into
       it; git grep 'under `automation/` by module' over its .assets: 0"; the script now resumes from leftover flat files and retries
       `git mv` on an index lock. Azure verdict: "15 diagram folders moved and rendered (45 stages clean, 0 orphans); LINKS 0, FILEMETA 0,
       SPELLING 0 over 76 pages; git grep 'under `automation/` by module' over its .assets: 0". All 149 diagrams are moved; design, flow,
       pipelines and repository render next. Left after them: azure, design (two batches), flow, pipelines, repository. Original step:
       Migration, one article folder at a time through the move command, `docs/explanation/configuration` first (the pilot's source): each
       diagram's nine files assembled under `<article-folder>/.assets/<name>/` with role names, the description inside, then
       `Build-Diagrams -Path` on each new folder. Check: `Test-Links`, `Test-FileMeta`, `Test-Spelling` clean on the folder before the next;
       the article folders done are listed in the plan as they land.
7. [x] Landed 2026-10-18 by session catzc-fb, verdict: "glyphs.drawio.png and glyphs.drawio.md moved to
       docs/explanation/.assets/glyphs/{diagram.drawio.png,diagram.drawio.md}; docs/explanation/index.md re-pointed; LINKS 0 over both
       pages; file-carriers.yml drops the flat explanation pattern and the glyphs exclusion". Original step: `glyphs.drawio.png` and
       `glyphs.drawio.md` into `docs/explanation/.assets/glyphs/` under role names. Check: every page that links it resolves (`Test-Links`
       over docs/explanation).
8. [x] Landed 2026-10-18, verdict: "the emptied docs/explanation/.assets/{grid,tree,chain} are gone; git ls-files docs/explanation/.assets
       lists only glyphs/"; Test-Links and Test-FileMeta 0 over docs/explanation; the Build-Diagrams dry run finds 150 folders; the old
       `*.grid.md` globs, the beside-the-article explanation kind and the flat carrier pattern are gone. Original step: Delete the emptied
       `docs/explanation/.assets/{grid,tree,chain}/`; `Build-Diagrams.ps1.md` help and `catzc-base-slides.md` responsibility:4 follow the
       parameter. Check: `git ls-files docs/explanation/.assets` lists only `glyphs/`; `Test-Links` on the two edited pages; the final full
       run is the tree-wide proof.
9. Tick the plan's steps as each lands; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero in plan-diagram-folders.

## Report

As report-fixed; the migration step reports the article folders done and the ones left.
