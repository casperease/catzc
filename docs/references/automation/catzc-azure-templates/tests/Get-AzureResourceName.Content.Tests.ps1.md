---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-AzureResourceName.Content.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8ebfe821ccd6"
---

# automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Content.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AzureResourceName...`, written with `#`.

```text
Data-driven coverage for Get-AzureResourceName, sourced from tests/assets/Get-AzureResourceName.Content.yml.
Each case is an input splat + an expected name (or an expected error). `input` is read via
$case.input (NOT bound as a -ForEach variable) because $input is a PowerShell automatic variable.
```
