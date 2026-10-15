<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Test-FileIsLocked.ps1
    kind: function
    module: Catzc.Base.Files
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether a file is held open by another handle (locked).
.DESCRIPTION
    Advisory on Unix, so it reports false there; use it to assert state, not as a guard before a delete.
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
