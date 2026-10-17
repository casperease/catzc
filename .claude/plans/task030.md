---
task:
  id: "030"
  status: open
  plans: [plan-format-step-moves-comments]
  value: low-medium
  blocked_on: nothing
  targets:
    [
      automation/Catzc.Base.Docs/configs/comments.yml,
      automation/Catzc.Base.QualityGates,
      docs/adr/repository/uniform-formatting.md,
      docs/adr/repository/comments-in-docs.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task030.md"
    folder: plans
    name: task030
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-REPO-COMMENTS#4
---

# task030: the format command moves long comments in the dot-folders

Verified 2026-10-17: `languages.yml` line 60 has top-level `imprint: [comments, file-meta]`, so the step loop exists and the comments step
is wired. The plan's first step closes with that fact. What remains: `comments.yml` `pages:` has `automation/*`, which never matches a
dot-prefixed folder, so `.scriptanalyzer` and `.internal` are out of scope and their long headers survive a format run. Decided (the
user's): page entries for the two folders with a reason each, `.vendor` excluded as third-party code.

## Steps

1. `plan-format-step-moves-comments.md`: tick the first step with the fact and the line number; clear `blocked_on`. Check: the head has no
   blocked_on.
2. `comments.yml` `pages:`: entries for `automation/.scriptanalyzer` (our rules, the longest headers) and `automation/.internal` (our loader
   and importer), each with its reason; `exclude:` gets `automation/.vendor` with "third-party code we do not edit". Confirm the config
   type's page-folder rule accepts a dot-prefixed source; fix the type if not (fresh pwsh). Check: CommentsConfig tests pass.
3. `Export-Comments -DryRun -PassThru` over the two folders in the background; review the count; then run it. The pages land where
   comments.yml says. Check: Test-Comments clean on both folders; the loader and importer still import (`New-Importer.Tests.ps1` and the
   build tests pass, since `.internal` loads before the module system).
4. `Format-Code -DryRun` on one file in each folder shows nothing left to move; a second run changes nothing (ADR-REPO-COMMENTS#4). Check:
   both dry runs empty.
5. `docs/adr/repository/uniform-formatting.md` rule 8 and `docs/adr/repository/comments-in-docs.md` rule 5: one sentence each, if not
   already there, that an imprint step may write the file's companion page and that the format command runs the move. Check:
   Test-AdrRegistry, Test-Links.
6. Tick the plan's second step; the carried draft goes; the plan is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
