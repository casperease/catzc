<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Assert-FileIsNotLocked.ps1
    kind: assert-function
    module: Catzc.Base.Files
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a file is free to open (not locked by another handle); throws otherwise.
.DESCRIPTION
    Locks are mandatory on Windows but advisory on Unix, where nothing counts as locked, so this never throws there.
.PARAMETER Path
    Path to the file to assert is not locked.
.PARAMETER ErrorText
    Optional message to throw instead of the default.
.EXAMPLE
    Assert-FileIsNotLocked $dllPath
#>
function Assert-FileIsNotLocked {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $ErrorText
    )

    if (Test-FileIsLocked $Path) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Expected file not to be locked, but it is held open: $Path"
        }
        throw $message
    }
}
