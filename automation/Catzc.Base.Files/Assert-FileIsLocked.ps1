<#
.SYNOPSIS
    Asserts that a file is held open by another handle (locked); throws otherwise.
.DESCRIPTION
    Throws when the file is not locked. See Test-FileIsLocked for how lock state is determined and the
    Windows-vs-Unix locking caveat.
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
