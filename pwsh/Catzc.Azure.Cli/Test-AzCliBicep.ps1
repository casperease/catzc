<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Test-AzCliBicep.ps1.md"
  header: "generated"
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
