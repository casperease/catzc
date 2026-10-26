<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md"
  header: "generated"
---
#>

function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track vendor_azure.bicep -TrackKind templates)
}
