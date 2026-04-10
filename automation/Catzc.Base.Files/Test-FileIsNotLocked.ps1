<#
.SYNOPSIS
    Tests whether a file is free to open (not locked by another handle).
.DESCRIPTION
    The inverse of Test-FileIsLocked. See its notes on Windows (mandatory) vs Linux/macOS (advisory) locking.
.PARAMETER Path
    Path to the file to test.
.EXAMPLE
    Test-FileIsNotLocked $dllPath
#>
function Test-FileIsNotLocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    -not (Test-FileIsLocked $Path)
}
