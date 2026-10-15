<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1
    kind: public-function
    module: Catzc.Azure.Templates
    visibility: public
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

    # Parenthesise the call so its (comma-wrapped, array-preserving) output is collected and then enumerated...
    # [comment:2](/docs/references/automation/catzc-azure-templates/Get-BicepTemplate.ps1.md#comment2)
    $template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    Assert-True ($null -ne $template) -ErrorText "Template '$Name' was not found"
    $template
}
