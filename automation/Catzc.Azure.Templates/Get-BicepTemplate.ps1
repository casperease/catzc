<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the descriptor for a single bicep template by name.
.PARAMETER Name
    Template name (the folder name under infrastructure/templates/).
.EXAMPLE
    $t = Get-BicepTemplate sample
    $t.main
    $t.environments
#>
function Get-BicepTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Name
    )

    # Without the parentheses, Where-Object receives the whole array as one object and matches every template.
    # [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplate.ps1.md#comment1)
    $template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    Assert-True ($null -ne $template) -ErrorText "Template '$Name' was not found"
    $template
}
