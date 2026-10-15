---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md
    kind: test-asset
    body_sha: fdc94730eb78
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-ASSETDEP#4
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1',...`.

```text
The coverage rule ([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4))
over the real tree, through its quality gate (Test-InternalAssetDependency —
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every Get-CatzcModuleRoot call site
passes literal values, and every function that reads an internal asset has a test citing
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) that is not
source-only, so the read is exercised in both the source run and the build run. It scans the source files
(per-function .ps1 and tests/), which only the source tree has — so the gate itself is source-only.
```
