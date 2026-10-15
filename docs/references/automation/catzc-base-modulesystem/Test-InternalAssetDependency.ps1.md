---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-InternalAssetDependency.ps1.md
    kind: comment-page
    body_sha: "1333ca820656"
    adrs:
      - ADR-AUTO-ASSETDEP#2
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-ASSETDEP#4
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) enforcing the
coverage rule [ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4) over the module
code. It collects an issue for:

  - every Get-CatzcModuleRoot call site whose -ChildPath or -Module is not a string literal
    ([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — such a
    site cannot be inventoried (Get-InternalAssetDependency -Violation);
  - every function with an internal asset dependency that no test citing
    [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) and not
    source-only covers, so the read is exercised in the source run and the build run
    (Get-UncoveredInternalAssetDependency).

It scans the per-function source files and tests, which exist only in the source tree.
```
