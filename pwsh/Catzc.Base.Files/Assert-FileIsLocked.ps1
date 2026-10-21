<#
---
catzc:
  immutable:
    with_body_sha: "06b1dbaf6826"
  edges:
    test: pwsh/Catzc.Base.Files/tests/Assert-FileIsLocked.Tests.ps1
    docs: "[Assert-FileIsLocked.ps1.md](../../docs/references/pwsh/catzc-base-files/Assert-FileIsLocked.ps1.md)"
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
