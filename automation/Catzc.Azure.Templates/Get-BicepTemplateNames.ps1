<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1
    name: get-bicep-template-names
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
---
#>

function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
