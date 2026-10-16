<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Assert-FileIsNotLocked.ps1
    name: assert-file-is-not-locked
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Asserts that a file is free to open (not locked by another handle); throws otherwise.
    description: |-
      Throws when the file is locked. See Test-FileIsLocked for how lock state is determined and the
      Windows-vs-Unix locking caveat.
    parameters:
      Path: Path to the file to assert is not locked.
      ErrorText: Optional message to throw instead of the default.
    examples:
      - Assert-FileIsNotLocked $dllPath
---
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
