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

    # Parenthesise the call so its (comma-wrapped, array-preserving) output is collected and then
    # enumerated element-by-element into Where-Object. A bare `Get-BicepTemplates | Where-Object`
    # feeds the whole array as a single pipeline object, which silently matches via member
    # enumeration and returns every template (latent until a second template exists).
    $template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    Assert-True ($null -ne $template) -ErrorText "Template '$Name' was not found"
    $template
}
