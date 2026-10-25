<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-PathExist.ps1.md"
  warning: "Generated Header"
---
#>

function Assert-PathExist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ValidateSet('Any', 'Container', 'Leaf')]
        [string] $PathType = 'Any',

        [string] $ErrorText
    )

    if (-not (Test-Path -Path $Path -PathType $PathType)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Path does not exist: $Path"
        }
        throw $message
    }
}
