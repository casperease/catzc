<#
.SYNOPSIS
    Compares two glob-pattern lists for equality — ordered for GitHub, as a set for Azure DevOps.
.DESCRIPTION
    The comparison behind the trigger-drift gates (Test-AdoPipelineTriggerGlob / Test-GitHubWorkflowTriggerGlob).
    ADO path filters are order-independent (union include minus union exclude), so a set comparison is
    correct and an ordinal sort makes it deterministic (ADR-XPLAT — Sort-Object is culture-aware). GitHub
    paths are ordered last-match-wins ('!' negation), so -Ordered compares element by element. Matching is
    case-sensitive (tracked paths are case-sensitive identities, ADR-GLOBS:2).
.PARAMETER Reference
    The expected pattern list.
.PARAMETER Difference
    The actual pattern list.
.PARAMETER Ordered
    Compare element by element (GitHub); omit for a set comparison (ADO).
.OUTPUTS
    [bool] $true when the lists are equal under the chosen comparison.
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
