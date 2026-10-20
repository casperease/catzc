<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
    folder: private
    name: test-glob-list-equal
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Test-GlobListEqual.ps1.md](docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md)"
    cites:
      - ADR-AUTO-XPLAT
      - ADR-FLOW-CD-GLOBS-REPOSITORYRELATIVEPATTERNS
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
