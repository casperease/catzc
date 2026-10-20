<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-BicepTemplate.ps1
    name: get-bicep-template
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
    docs: "[Get-BicepTemplate.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplate.ps1.md)"
---
#>

function Get-BicepTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Name
    )

    $template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    Assert-True ($null -ne $template) -ErrorText "Template '$Name' was not found"
    $template
}
