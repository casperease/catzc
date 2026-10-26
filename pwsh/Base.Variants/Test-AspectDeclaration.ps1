<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md"
  header: "generated"
---
#>

function Test-AspectDeclaration {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Track
    )

    $aspects = Get-AspectDeclaration
    $null -ne $aspects -and $aspects.ContainsKey($Track)
}
