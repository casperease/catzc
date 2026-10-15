---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
    kind: test-asset
    body_sha: b4f98c377fed
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-ASSETDEP#4
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-UncoveredInternalAssetDependency' -Tag 'L0', 'logic' {`.

```text
The coverage quality gate's engine
([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)) over a TestKit
fixture tree: which functions with an internal
asset dependency lack a test that cites
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) and is not
source-only. The fixture test files are
parsed, never run. Neutral names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
