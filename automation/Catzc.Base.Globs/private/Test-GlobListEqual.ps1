<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
    folder: private
    name: test-glob-list-equal
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-XPLAT
      - ADR-FLOW-CD-GLOBS#2
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
