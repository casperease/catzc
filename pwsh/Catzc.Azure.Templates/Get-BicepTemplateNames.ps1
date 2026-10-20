<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1
    name: get-bicep-template-names
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
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
    docs: "[Get-BicepTemplateNames.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateNames.ps1.md)"
---
#>

function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
