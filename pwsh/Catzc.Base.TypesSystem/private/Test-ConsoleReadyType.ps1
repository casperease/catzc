<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-types-system/private/Test-ConsoleReadyType.ps1.md"
  warning: "Generated Header"
---
#>

function Test-ConsoleReadyType {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [type] $Type
    )

    if ($Type.IsEnum -or $Type.IsInterface -or $Type.IsAbstract -or
        [System.Delegate].IsAssignableFrom($Type) -or [System.Attribute].IsAssignableFrom($Type) -or
        [System.Exception].IsAssignableFrom($Type)) {
        return $true
    }
    $declaringType = $Type.GetMethod('ToString', [type[]]@()).DeclaringType
    return $declaringType -ne [object] -and $declaringType -ne [System.ValueType]
}
