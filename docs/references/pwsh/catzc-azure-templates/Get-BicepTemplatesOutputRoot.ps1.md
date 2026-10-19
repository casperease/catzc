# automation/pwsh/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the root folder Build-Bicep writes template build output under.

### description

The output-side twin of Get-BicepTemplatesRoot: templates' output_folder descriptors resolve to `<output root>/template/<name>`, and this
function owns the root — `<repository>/out` by default. It exists as a seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): build tests mock it
to a folder of their own so no two test files ever write the same build folder (a fixed out/ path two files both write is the serial-tag
race, [ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../adr/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool) — mocking the seam
removes the sharing instead). Keep any mocked root under the repository when the test also asserts the repo-relative artifact contract
(Get-BicepDeploymentContext relativizes against the repository root).

### outputs

`[string]` the absolute output root path.

### example 1

```powershell
Get-BicepTemplatesOutputRoot
```
