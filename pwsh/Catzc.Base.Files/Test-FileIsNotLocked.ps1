<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Test-FileIsNotLocked.ps1.md"
  warning: "Generated Header"
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
