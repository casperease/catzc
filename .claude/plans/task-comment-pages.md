---
task:
  status: open
  plans: [plan-minimal-heads]
  value: highest
  blocked_on: nothing
  targets:
    [
      pwsh/Catzc.Base.CodeMeta,
      pwsh/Catzc.Base.QualityGates/configs/comments.yml,
      pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs,
      pwsh/Catzc.Base.QualityGates/types/CommentPageMap.cs,
      pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1,
    ]
---

# Task: the comment-page map moves to a module both heads load

plan-minimal-heads' first open step, written out. The `pages` map leaves `comments.yml` for a `comment-pages` config in
`Catzc.Base.CodeMeta`, which `Catzc.Base.Languages` (its carrier types) and `Catzc.Base.QualityGates` (five head callers) already load, so
`Format-GeneratedFileHead` derives its `docs` edge with the same call the relative-edges processor makes (ADR-PRIN-ONELIVE, one mechanism;
the home module is the planner's pick, 2026-10-21). Every caller moves in this task, never a second path beside the first. One file per
step, verified before the next. Steps 1 to 3 and 12 change a type, so each check runs in a fresh `pwsh` process; the old shape is deleted
only after every caller has moved, so no session's import path breaks in between.

## Steps

1. `pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs`: the type moves here from `pwsh/Catzc.Base.QualityGates/types/`, namespace
   `Catzc.Base.CodeMeta`, the old file deleted. Check: a fresh import loads without a type error.
2. `pwsh/Catzc.Base.CodeMeta/types/CommentPagesConfig.cs` (new): `pages`, `DefaultPages` and `PageFor(string)` moved from
   `CommentsConfig.cs`, the defaults declared once on this type (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER). Check: a new
   `pwsh/Catzc.Base.CodeMeta/tests/types/CommentPagesConfig.Tests.ps1`, its cases moved from the `pages` cases of
   `CommentsConfig.Tests.ps1`, passes under `Invoke-TestFile`.
3. `pwsh/Catzc.Base.CodeMeta/configs/comment-pages.yml` (new): the `pages:` list of `comments.yml`, verbatim. Check: in a fresh import,
   `(Get-Config -Config comment-pages).PageFor('pwsh/Catzc.Base.Languages/Get-FileLanguage.ps1')` returns its page.
4. `pwsh/Catzc.Base.CodeMeta/Get-CommentPage.ps1` (new, public): `-Path` returns the page or nothing, with its test file. Check:
   `Invoke-TestFile` on `pwsh/Catzc.Base.CodeMeta/tests/Get-CommentPage.Tests.ps1`.
5. `pwsh/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1:49` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
   `tests/Get-AdrCodesFileMetaFact.Tests.ps1`.
6. `pwsh/Catzc.Base.QualityGates/private/Get-AdrUsageRow.ps1:58` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
   `tests/Get-AdrUsageRow.Tests.ps1`.
7. `pwsh/Catzc.Base.QualityGates/private/Get-CommentScope.ps1:75` calls `Get-CommentPage`. Check: `Invoke-TestFile` on the `Export-Comments`
   tests, which drive the scope.
8. `pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1:48` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
   `tests/Invoke-FileMetaEngine.Tests.ps1`.
9. `pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgeCandidate.ps1:77` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
   `tests/Get-RelativeEdgesFileMetaFact.Tests.ps1`.
10. `pwsh/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1:82` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
    `tests/Invoke-ImprintStep.Tests.ps1`.
11. `pwsh/Catzc.Base.QualityGates/private/Move-FunctionHelp.ps1:49` calls `Get-CommentPage`. Check: `Invoke-TestFile` on
    `tests/Move-FunctionHelp.Tests.ps1`.
12. `pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs` and `configs/comments.yml`, after every caller has moved: `pages`, `DefaultPages`
    and `PageFor` deleted, and the `pages` cases leave `tests/types/CommentsConfig.Tests.ps1`; `tests/Format-FileMeta.Tests.ps1:71` builds
    `CommentPagesConfig` instead, and `configs/source-conventions.yml:78-79` names `CommentPagesConfig.DefaultPages`. Check: in a fresh
    `pwsh`, `Invoke-TestFile` on both test files. 12a. Layering (the user, 2026-10-21): `Catzc.Base.CodeMeta` reads no config, so
    `Get-CommentPage` takes a mandatory `-Config [CommentPagesConfig]` and each caller of steps 5 to 11 passes
    `(Get-Config -Config comment-pages)`; one file per step. Check: `Invoke-TestFile` on each caller's test named in its step, and on
    `Get-CommentPage.Tests.ps1`. 12b. The comment pages: `comments.yml.md`'s note above `pages:` moves to a new `comment-pages.yml.md`;
    `CommentsConfig.cs.md:25` loses its `pages` line; `docs/references/pwsh/catzc-base-codemeta.md` gains `Get-CommentPage` in its Division
    table. Check: `Test-Links` on the three pages. 12c. `docs/adr/repository/comments-in-docs.md:10,31` and
    `docs/adr/repository/function-help.md:8`: the page map is named as the `comment-pages` config of `Catzc.Base.CodeMeta`, not
    `comments.yml`'s `pages`; one file per step. Check: `Test-Links` and `Test-AdrRegistry` on each.
13. `pwsh/Catzc.Base.Languages/Format-GeneratedFileHead.ps1`: the `docs` edge derived with `Get-CommentPage`, written by the same
    `[{leaf}]({path})` template. Check: `Invoke-TestFile` on `pwsh/Catzc.Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1` with a
    case for a generated file that has a page.
14. No caller left on the old shape. Check: a Grep for `PageFor` and `-Config comments).Page` under `pwsh/` finds only
    `CommentPagesConfig.cs` and its test; a fresh full import loads.

## Report

As report-fixed; then plan-minimal-heads' first open step is deleted and its master line updated.
