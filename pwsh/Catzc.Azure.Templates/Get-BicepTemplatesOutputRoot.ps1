<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md"
  header: "generated"
---
#>

function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
