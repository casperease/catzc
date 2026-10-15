---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-AzureResourceName.Content.Tests.ps1.md
    kind: test-asset
    body_sha: "2cdc464e6837"
---

# automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Content.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AzureResourceName...`.

```text
Data-driven coverage for Get-AzureResourceName, sourced from tests/assets/Get-AzureResourceName.Content.yml.
Each case is an input splat + an expected name (or an expected error). `input` is read via
$case.input (NOT bound as a -ForEach variable) because $input is a PowerShell automatic variable.
```
