# catzc:
#   path: automation/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1
#   module: Catzc.Base.TypesSystem
#   visibility: private

<#
.SYNOPSIS
    Whether a shipped C# type renders as one readable line in pwsh, rather than as its full name.
.DESCRIPTION
    Only a real ToString() override counts, because pwsh string conversion ignores an ETS ToString.
    [comment:1](/docs/references/automation/catzc-base-typessystem/private/Test-ConsoleReadyType.ps1.md#comment1)
.PARAMETER Type
    The loaded type to check.
.OUTPUTS
    [bool] True when the type is console-ready or exempt.
.EXAMPLE
    Test-ConsoleReadyType -Type ([Catzc.Base.Objects.ArtifactRef])
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
