---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md
    kind: test-asset
    body_sha: "720c05c7a55e"
    adrs:
      - ADR-AUTO-ASSETDEP#2
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-InternalAssetDependency' -Tag 'L0', 'logic' {`.

```text
The inventory of internal asset dependencies
([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — one record per
Get-CatzcModuleRoot call
site, derived from the code by AST. Logic over a TestKit fixture tree with neutral names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
