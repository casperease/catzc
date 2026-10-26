# pwsh/Azure.Templates/Get-BicepTemplatesOutputRoot.ps1

The function that returns the root folder `Build-Bicep` writes template build output under.

## help

### synopsis

Returns the root folder Build-Bicep writes template build output under.

### description

The output-side twin of Get-BicepTemplatesRoot: templates' output_folder descriptors resolve to `<output root>/template/<name>`, and this
function owns the root — `<repository>/out` by default. It exists as a seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): build
tests mock it to a folder of their own so no two test files ever write the same build folder (a fixed out/ path two files both write is the
serial-tag race, [ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool) —
mocking the seam removes the sharing instead). Keep any mocked root under the repository when the test also asserts the repo-relative
artifact contract (Get-BicepDeploymentContext relativizes against the repository root).

### outputs

`[string]` the absolute output root path.

### example 1

```powershell
Get-BicepTemplatesOutputRoot
```
