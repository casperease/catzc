<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1
    name: get-bicep-template
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-templates/Get-BicepTemplate.ps1.md
    test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
  config:
    synopsis: Returns the descriptor for a single bicep template by name.
    parameters:
      Name: Template name (the folder name under infrastructure/templates/).
    examples:
      - |-
        $t = Get-BicepTemplate sample
        $t.main
        $t.environments
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
