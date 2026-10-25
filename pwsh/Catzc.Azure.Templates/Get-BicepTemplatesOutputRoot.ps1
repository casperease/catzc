<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md"
  warning: "Generated Header"
---
#>

function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
