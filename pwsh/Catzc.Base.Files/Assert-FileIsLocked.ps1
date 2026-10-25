<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Assert-FileIsLocked.ps1.md"
  warning: "Generated Header"
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
