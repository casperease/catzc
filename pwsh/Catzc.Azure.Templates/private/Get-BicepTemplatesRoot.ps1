<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1
    folder: private
    name: get-bicep-templates-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplatesRoot.Tests.ps1
    docs: "[Get-BicepTemplatesRoot.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md)"
---
#>

function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track infrastructure -TrackKind templates)
}
