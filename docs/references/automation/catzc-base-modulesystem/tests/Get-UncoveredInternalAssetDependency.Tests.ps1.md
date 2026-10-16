---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "77ac509bd65a"
    adrs:
      - ADR-AUTO-ASSETDEP#{3,4}
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-UncoveredInternalAssetDependency' -Tag 'L0', 'logic' {`, written with `#`.

```text
The coverage quality gate's engine
([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)) over a TestKit
fixture tree: which functions with an internal
asset dependency lack a test that cites
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) and is not
source-only. The fixture test files are
parsed, never run. Neutral names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
