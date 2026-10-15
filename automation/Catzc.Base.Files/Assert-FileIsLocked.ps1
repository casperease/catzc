<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Assert-FileIsLocked.ps1
    kind: function
    module: Catzc.Base.Files
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a file is held open by another handle (locked); throws otherwise.
.DESCRIPTION
    Locks are mandatory on Windows but advisory on Unix, where nothing counts as locked, so this always throws there.
.PARAMETER Path
    Path to the file to assert is locked.
.PARAMETER ErrorText
    Optional message to throw instead of the default.
.EXAMPLE
    Assert-FileIsLocked $dllPath
#>
function Assert-FileIsLocked {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $ErrorText
    )

    if (-not (Test-FileIsLocked $Path)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Expected file to be locked, but it is free to open: $Path"
        }
        throw $message
    }
}
