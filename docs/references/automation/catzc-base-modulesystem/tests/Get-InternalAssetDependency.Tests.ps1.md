---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: get-internal-asset-dependency-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f00c2a67ad37
    adrs:
      - ADR-AUTO-ASSETDEP#2
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-InternalAssetDependency' -Tag 'L0', 'logic' {`, written with `#`.

```text
The inventory of internal asset dependencies
([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — one record per
Get-CatzcModuleRoot call
site, derived from the code by AST. Logic over a TestKit fixture tree with neutral names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
