<#
---
catzc:
  immutable:
    with_body_sha: "2f266f2c7020"
  edges:
    docs: "[Test-FileIsNotLocked.ps1.md](docs/references/pwsh/catzc-base-files/Test-FileIsNotLocked.ps1.md)"
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
