<#
---
catzc:
  immutable:
    with_body_sha: "4f85f72032ab"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-PathExist.Tests.ps1
    docs: "[Assert-PathExist.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-PathExist.ps1.md)"
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
