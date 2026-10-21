<#
---
catzc:
  immutable:
    with_body_sha: a476f3ce2e1d
  edges:
    test: pwsh/Catzc.Base.Files/tests/Test-FileIsLocked.Tests.ps1
    docs: "[Test-FileIsLocked.ps1.md](../../docs/references/pwsh/catzc-base-files/Test-FileIsLocked.ps1.md)"
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
