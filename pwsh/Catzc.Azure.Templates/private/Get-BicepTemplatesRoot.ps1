<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md"
  warning: "Generated Header"
---
#>

function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track infrastructure -TrackKind templates)
}
