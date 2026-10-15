<#
.SYNOPSIS
    Tests whether a file is held open by another handle (locked).
.DESCRIPTION
    Tries to open the file for reading with no sharing.
    [comment:1](/docs/references/automation/catzc-base-files/Test-FileIsLocked.ps1.md#comment1)
.PARAMETER Path
    Path to the file to test.
.EXAMPLE
    Test-FileIsLocked $dllPath
#>
function Test-FileIsLocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf

    try {
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::None)
        $stream.Dispose()
        $false
    }
    catch [System.IO.IOException] {
        $true
    }
}
