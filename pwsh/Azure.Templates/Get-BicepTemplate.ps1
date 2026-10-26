function Get-BicepTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Name
    )

    # Parenthesised so the comma-wrapped array is enumerated into Where-Object; bare, it arrives as one object and matches every template.
    $template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    Assert-True ($null -ne $template) -ErrorText "Template '$Name' was not found"
    $template
}
