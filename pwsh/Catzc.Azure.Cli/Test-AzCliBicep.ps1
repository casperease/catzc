<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Test-AzCliBicep.ps1.md"
  warning: "Generated Header"
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
