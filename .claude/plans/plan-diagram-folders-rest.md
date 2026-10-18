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
- [ ] The user runs `out/move-rest-diagrams.ps1` (it stages `git mv`) (check: `git ls-files 'docs/.assets/*/*.drawio.png'` lists nothing).
- [ ] `Build-Diagrams -Path` on each new folder, one at a time (check: all stages clean on each; Test-Links over docs/ clean).
- [ ] Delete this plan (check: no file in .claude/plans names it).
