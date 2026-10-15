<#
.SYNOPSIS
    Compares two glob-pattern lists for equality — ordered for GitHub, as a set for Azure DevOps.
.DESCRIPTION
    Matching is case-sensitive and the set sort is ordinal, since Sort-Object is culture-aware and would vary by host.
    [ADR-AUTO-XPLAT](/docs/adr/automation/cross-platform.md),
    [ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2)
    [comment:1](/docs/references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md#comment1)
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
