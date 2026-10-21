<#
---
catzc:
  immutable:
    with_body_sha: "37f981ad9e3e"
  edges:
    docs: "[Test-GlobListEqual.ps1.md](docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md)"
    cites:
      - ADR-AUTO-XPLAT
      - FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS
---
#>

function Test-GlobListEqual {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [AllowEmptyCollection()]
        [string[]] $Reference,

        [AllowEmptyCollection()]
        [string[]] $Difference,

        [switch] $Ordered
    )

    $left = @($Reference)
    $right = @($Difference)
    if ($left.Count -ne $right.Count) {
        return $false
    }

    if (-not $Ordered) {
        $left = [string[]] $left
        $right = [string[]] $right
        [System.Array]::Sort($left, [System.StringComparer]::Ordinal)
        [System.Array]::Sort($right, [System.StringComparer]::Ordinal)
    }

    for ($i = 0; $i -lt $left.Count; $i++) {
        if ($left[$i] -cne $right[$i]) {
            return $false
        }
    }
    $true
}
