<#
.SYNOPSIS
    Asserts that a file is free to open (not locked by another handle); throws otherwise.
.DESCRIPTION
    Throws when the file is locked.
    [comment:1](/docs/references/automation/catzc-base-files/Assert-FileIsNotLocked.ps1.md#comment1)
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
