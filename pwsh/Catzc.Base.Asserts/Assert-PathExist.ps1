<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-PathExist.ps1.md"
  header: "generated"
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
        # A [string] parameter turns $null into '', which ?? never coalesces, so only a truth test lets the default
        # message through.
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Path does not exist: $Path"
        }
        throw $message
    }
}
