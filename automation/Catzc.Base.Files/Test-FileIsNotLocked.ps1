<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Test-FileIsNotLocked.ps1
    name: test-file-is-not-locked
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Tests whether a file is free to open (not locked by another handle).
    description: The inverse of Test-FileIsLocked. See its notes on Windows (mandatory) vs Linux/macOS (advisory) locking.
    parameters:
      Path: Path to the file to test.
    examples:
      - Test-FileIsNotLocked $dllPath
---
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
