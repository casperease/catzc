<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Test-FileIsLocked.ps1
    name: test-file-is-locked
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Test-FileIsLocked.Tests.ps1
  config:
    synopsis: Tests whether a file is held open by another handle (locked).
    description: |-
      Tries to open the file for reading with no sharing. If another handle is open (e.g. a loaded assembly
      DLL), the open fails with an IOException and the file is reported locked; if the open succeeds it is
      closed immediately and the file is reported not locked.

      File locking is mandatory on Windows but advisory on Linux/macOS, where a file held open elsewhere may
      still open — so this reports $false there. Callers that must not stall on a locked file (e.g. cache
      cleanup) should still prefer a guarded delete; this predicate is for asserting and reporting state.
    parameters:
      Path: Path to the file to test.
    examples:
      - Test-FileIsLocked $dllPath
---
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
