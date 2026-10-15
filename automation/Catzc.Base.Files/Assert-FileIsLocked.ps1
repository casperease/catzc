<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Assert-FileIsLocked.ps1
    kind: assert-function
    module: Catzc.Base.Files
    visibility: public
  config:
    synopsis: Asserts that a file is held open by another handle (locked); throws otherwise.
    description: |-
      Throws when the file is not locked. See Test-FileIsLocked for how lock state is determined and the
      Windows-vs-Unix locking caveat.
    parameters:
      Path: Path to the file to assert is locked.
      ErrorText: Optional message to throw instead of the default.
    examples:
      - Assert-FileIsLocked $dllPath
---
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
