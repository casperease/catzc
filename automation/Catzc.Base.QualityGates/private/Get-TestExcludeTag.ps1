<#
.SYNOPSIS
    Computes the Pester ExcludeTag list for a tier range + category — shared by Test-Automation and
    Test-InIsolation so the tier/category filter has one definition.
.DESCRIPTION
    Excludes every tier tag outside [MinLevel, MaxLevel] and, when -Category is Logic or Integrity, the OTHER
    category's tag. ExcludeTag values are lowercase to match the test files' actual tags ('logic'/'integrity');
    tier tags are 'L0'..'L3'. A mixed file's per-Context category tags filter correctly because ExcludeTag
    matches an item's own tag.
.PARAMETER MinLevel
    Lowest tier to keep (0-3). Tiers below it are excluded.
.PARAMETER MaxLevel
    Highest tier to keep (0-3). Tiers above it are excluded.
.PARAMETER Category
    Logic (exclude integrity), Integrity (exclude logic), or Both (exclude neither).
.EXAMPLE
    Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic   # -> L2, L3, integrity
#>
function Get-TestExcludeTag {
    [OutputType([string[]])]
    param(
        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3)]
        [int] $MaxLevel = 2,

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both'
    )

    $excludeTags = [System.Collections.Generic.List[string]]::new()
    if ($MaxLevel -lt 3) {
        $excludeTags.Add('L3')
    }
    if ($MaxLevel -lt 2) {
        $excludeTags.Add('L2')
    }
    if ($MaxLevel -lt 1) {
        $excludeTags.Add('L1')
    }
    if ($MinLevel -gt 0) {
        $excludeTags.Add('L0')
    }
    if ($MinLevel -gt 1) {
        $excludeTags.Add('L1')
    }
    if ($MinLevel -gt 2) {
        $excludeTags.Add('L2')
    }
    # Lowercase to match the test files' actual category tags.
    if ($Category -eq 'Logic') {
        $excludeTags.Add('integrity')
    }
    elseif ($Category -eq 'Integrity') {
        $excludeTags.Add('logic')
    }

    [string[]] $excludeTags
}
