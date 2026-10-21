# pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1',...`, written with `#`.

```text
The coverage rule ([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically))
over the real tree, through its quality gate (Test-InternalAssetDependency —
[ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every Get-CatzcModuleRoot call site
passes literal values, and every function that reads an internal asset has a test citing
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest) that is not
source-only, so the read is exercised in both the source run and the build run. It scans the source files
(per-function .ps1 and tests/), which only the source tree has — so the gate itself is source-only.
```
