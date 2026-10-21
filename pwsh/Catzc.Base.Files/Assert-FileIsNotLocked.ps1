<#
---
catzc:
  immutable:
    with_body_sha: eff2ea30394b
  edges:
    docs: "[Assert-FileIsNotLocked.ps1.md](../../docs/references/pwsh/catzc-base-files/Assert-FileIsNotLocked.ps1.md)"
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
