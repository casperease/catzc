---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  waits_on: the user's run of the move script (Move-Diagram stages a git mv)
  targets: [docs/.assets, docs/references/.assets]
---

# Diagram folders: the 16 slides outside docs/explanation

Every `docs/explanation` slide sits in its own folder beside its article, `<article-folder>/.assets/<name>/`, moved with `Move-Diagram` and
built with `Build-Diagrams -Path`. Sixteen slides are still flat files: 5 in `docs/.assets` and 11 in `docs/references/.assets/automation`
(`git ls-files 'docs/**/.assets/*.drawio.png' 'docs/.assets/*/*.drawio.png'` without the `diagram.drawio.png` folders). A references slide
is three files, its png, its `.drawio.verify.md` and its description `docs/references/pwsh/<module>/<stem>.drawio.md`, and all three move
into its folder. Carried from plan-diagram-folders, which is done and listed for deletion.

## Open steps

- [x] Prepare, read-only: for each slide, the page that embeds it, its target folder by the diagram-folder rule, and one
      `Move-Diagram <from> <to>` line per file; each line proven with `-DryRun`. The references slides move after the references asset
      folder `git mv` (automation to pwsh, task-user-runs-and-commits), so their lines use the `pwsh/` path (check:
      `out/move-rest-diagrams.ps1` holds one line per file, each with a clean dry run recorded in `out/move-rest-diagrams.dryrun.txt`).
      Verdict (catzc-a2): "DRY RUNS: 38 of 38 clean" for the 16 embedded slides (5 single files, 11 of three files each). Folder:
      `<embedding page's folder>/.assets/<stem>/`, the files under the role names `diagram.drawio.png`, `diagram.drawio.md` and
      `diagram.drawio.verify.md`.
- [x] `pwsh/Catzc.Base.Slides/Move-Diagram.ps1`: under `-PassThru`, `@($edits.Page)` throws under strict mode when no page links the moved
      file ("The property 'Page' cannot be found"), as the prepare's dry run of the get-config-merge-seal-type verify note showed; `Pages`
      is built with `foreach`, and the L0 case "returns no pages under -PassThru when no page links the moved file" holds it (check: the
      case fails before the fix, the test file passes after). Verdict (catzc-a2): before, "FAIL Move-Diagram.returns no pages under
      -PassThru when no page links the moved file"; after, "[Invoke-TestFile] Passed (in-place)" (`out/test-file/20261018-194226-9295a8`).
- [x] `docs/adr/design/.assets/new-design-stack.drawio.png`: no tracked file names it, so it has no page to sit beside and no line in the
      script (check: the slide is gone, or its page embeds it and the script holds its line with a clean dry run). Decided by the user
      2026-10-18: delete it; its `git rm` line is in `out/delete-done-plans.ps1` for the user's run.
- [x] The user runs `out/move-rest-diagrams.ps1` (it stages `git mv`) (check: `git ls-files 'docs/.assets/*/*.drawio.png'` lists nothing).
      Done 2026-10-18 by the user (`out/run-user-git.ps1`): the check lists 0 files.
- [x] `Build-Diagrams -Path` on each new folder, one at a time (check: all stages clean on each; Test-Links over docs/ clean). Run
      2026-10-18 (`out/build-rest-folders.ps1`): the 11 reference folders under `docs/references/pwsh/.assets/` "prepare=clean
      highlight=clean join=clean"; Test-Links over docs/ issues=0 after the 22 links into the old `docs/references/.assets/automation/` path
      were re-pointed (`out/test-links/20261018-200355`). Blocked on five slides whose model has no subtitle cell, the one warning each
      ("warn W_SUBTITLE …: the model has no subtitle cell", prepare=warnings, every artifact delivered):
      `docs/adr/azure/.assets/azure-name-assembly`, `docs/explanation/design/.assets/10-commits-story`,
      `docs/adr/design/.assets/commit-lifecycle-states`, `docs/explanation/design/.assets/state-changes`,
      `docs/adr/design/.assets/sync-point`. Decided by the orchestrator (delegated): each is migrated to the dark tokens with the
      sidebar and an ADR-level subtitle, numbered citations named from the slug map. Landed 2026-10-18 by catzc-a2 for sync-point,
      commit-lifecycle-states and azure-name-assembly: "prepare 0 clean, highlight 0 clean, join 0 clean", 0 W_ lines each, every
      numbered citation named (4, 8 and 7), only the title moved to make room, long citations broken onto their own line, two boxes in
      azure-name-assembly widened; each raster read in the dark theme with nothing overlapping that the light original did not.
      10-commits-story and state-changes landed the same way after the renderer step below: "prepare 0 clean, highlight 0 clean, join 0
      clean", 0 W_ lines each, and each raster keeps every arrow and line its light original has (the span arrows, the push/pull block
      arrows, the gate lines, the git branch curves, every discard arrow; state-changes' skip edge is a rounded polyline where the
      original curves). Test-Links on the four embedding pages and the 15 generated pages of the five folders: "issues 0";
      `out/scan-numbered-models.py`: "SCANNED 166 folders, 0 with hits". The migrated state-changes in the working tree replaces the
      lossy copy in HEAD (7010cea99) at the user's next commit.
- [x] The kit renderer (`.claude/drawio/drawio_png.py`) draws what the draw.io-authored slides use, each added with a test in
      `.claude/drawio/tests/test_drawio_png.py` that failed first (check: the kit tests pass). Verdict (catzc-a2): edges given by
      `sourcePoint`/`targetPoint`, inside a group at its offset, with `startArrow`; waypoints, with rounded corners for `rounded=1`;
      `shape=flexArrow` block arrows; a `group` cell paints nothing; a `whiteSpace=wrap` label wraps at its cell width; an opening
      `<div>` starts a line; an `rgb()` font colour is read; and the in-place re-render no longer loses its `--page`. "32 passed".
- [x] Numbered citations left in 12 slide models outside docs/explanation (the widened `out/scan-numbered-models.py`: the glyph legend
      `docs/explanation/.assets/glyphs` and the 11 `docs/references/pwsh/.assets/*` slides), re-cited the way step 6 of the code language
      did: named rules, chips on slide-local keys with a legend naming each rule (check: Build-Diagrams -Path clean on each; the scan
      reports 0 over all 166 folders). Landed 2026-10-18 by catzc-b4. The 11 reference slides carried their numbered codes only in the
      sidebar `supports` cell; decided by the orchestrator (the user's option A: the slide names ADRs, the article names rules), it now
      lists ADR-level codes, deduped, which fit the box (named rules overflowed it). The glyph legend's sample chip reads `3` and its footer
      cites ADR-DSGN-VISUAL-FIXEDCOMMITPALETTE. "Build-Diagrams -Path all stages clean on the 11 reference folders, 0 W_ lines, 0 other
      cells changed (out/b4-chips/celldiff.py); the glyph legend all stages done, prepare with its known W_SUBTITLE (it has no subtitle
      cell, and a standard one at y 44 overlaps its first band at y 56, so none was added), 0 other cells changed; out/scan-numbered-models.py:
      SCANNED 166 folders, 0 with hits, 0 numbered codes, 0 chip labels". Then, decided by the orchestrator (configure, don't program): the
      glyph legend is a legend, not a slide. `.claude/drawio/drawio.yml` declares `renderer.role: slide` once and a `roles:` map naming
      `docs/explanation/.assets/glyphs: legend`; `folder_role` in `drawio_forward.py` reads it and `subtitle_facts` raises no W_SUBTITLE for a
      legend. "kit pytest: 25 passed (three new cases: a legend without a subtitle has no warning, a slide without one is warned, a role
      outside the closed set is refused); Build-Diagrams -Path docs/explanation/.assets/glyphs prepare=clean highlight=clean join=clean, 0 W_
      lines; tools-yml-install-dispatch prepare=clean highlight=clean join=clean".
- [ ] Delete this plan (check: no file in .claude/plans names it).
