# pwsh/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-UncoveredInternalAssetDependency' -Tag 'L0', 'logic' {`, written with `#`.

```text
The coverage quality gate's engine
([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically)) over a TestKit
fixture tree: which functions with an internal
asset dependency lack a test that cites
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest) and is not
source-only. The fixture test files are
parsed, never run. Neutral names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
