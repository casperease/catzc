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
(`git ls-files 'docs/**/.assets/*.drawio.png' 'docs/.assets/*/*.drawio.png'` without the `diagram.drawio.png` folders). A references slide is three files, its png, its `.drawio.verify.md` and its description
`docs/references/pwsh/<module>/<stem>.drawio.md`, and all three move into its folder. Carried from plan-diagram-folders, which is done and
listed for deletion.

## Open steps

- [x] Prepare, read-only: for each slide, the page that embeds it, its target folder by the diagram-folder rule, and one
      `Move-Diagram <from> <to>` line per file; each line proven with `-DryRun`. The references slides move after the references asset
      folder `git mv` (automation to pwsh, task-user-runs-and-commits), so their lines use the `pwsh/` path (check:
      `out/move-rest-diagrams.ps1` holds one line per file, each with a clean dry run recorded in `out/move-rest-diagrams.dryrun.txt`).
      Verdict (catzc-a2): "DRY RUNS: 38 of 38 clean" for the 16 embedded slides (5 single files, 11 of three files each). Folder:
      `<embedding page's folder>/.assets/<stem>/`, the files under the role names `diagram.drawio.png`, `diagram.drawio.md` and
      `diagram.drawio.verify.md`.
- [x] `pwsh/Catzc.Base.Slides/Move-Diagram.ps1`: under `-PassThru`, `@($edits.Page)` throws under strict mode when no page links the
      moved file ("The property 'Page' cannot be found"), as the prepare's dry run of the get-config-merge-seal-type verify note showed;
      `Pages` is built with `foreach`, and the L0 case "returns no pages under -PassThru when no page links the moved file" holds it (check:
      the case fails before the fix, the test file passes after). Verdict (catzc-a2): before, "FAIL Move-Diagram.returns no pages under
      -PassThru when no page links the moved file"; after, "[Invoke-TestFile] Passed (in-place)" (`out/test-file/20261018-194226-9295a8`).
- [x] `docs/adr/design/.assets/new-design-stack.drawio.png`: no tracked file names it, so it has no page to sit beside and no line in the
      script (check: the slide is gone, or its page embeds it and the script holds its line with a clean dry run). Decided by the user
      2026-10-18: delete it; its `git rm` line is in `out/delete-done-plans.ps1` for the user's run.
- [x] The user runs `out/move-rest-diagrams.ps1` (it stages `git mv`) (check: `git ls-files 'docs/.assets/*/*.drawio.png'` lists nothing).
      Done 2026-10-18 by the user (`out/run-user-git.ps1`): the check lists 0 files.
- [ ] `Build-Diagrams -Path` on each new folder, one at a time (check: all stages clean on each; Test-Links over docs/ clean). Run
      2026-10-18 (`out/build-rest-folders.ps1`): the 11 reference folders under `docs/references/pwsh/.assets/` "prepare=clean
      highlight=clean join=clean"; Test-Links over docs/ issues=0 after the 22 links into the old `docs/references/.assets/automation/`
      path were re-pointed (`out/test-links/20261018-200355`). Blocked on five slides whose model has no subtitle cell, the one warning
      each ("warn W_SUBTITLE …: the model has no subtitle cell", prepare=warnings, every artifact delivered):
      `docs/adr/azure/.assets/azure-name-assembly`, `docs/explanation/design/.assets/10-commits-story`,
      `docs/adr/design/.assets/commit-lifecycle-states`, `docs/explanation/design/.assets/state-changes`,
      `docs/adr/design/.assets/sync-point`. Adding a cell is diagram work for the user to ask for.
- [ ] Delete this plan (check: no file in .claude/plans names it).
