<#
.SYNOPSIS
    Computes the Pester ExcludeTag list for a tier range + category — shared by Test-Automation and
    Test-InIsolation so the tier/category filter has one definition.
.DESCRIPTION
    Tags are lowercase to match the files, and ExcludeTag matches an item's own tag, so mixed files filter per Context.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestExcludeTag.ps1.md#comment1)
.PARAMETER MinLevel
    Lowest tier to keep (0-4). Tiers below it are excluded.
.PARAMETER MaxLevel
    Highest tier to keep (0-4). Tiers above it are excluded.
.PARAMETER Category
    Logic (exclude integrity), Integrity (exclude logic), or Both (exclude neither).
.EXAMPLE
    Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic   # -> L2, L3, integrity
#>
function Get-TestExcludeTag {
    [OutputType([string[]])]
    param(
        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MaxLevel = 2,

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both'
    )

    # Tiers above the range, highest first, then tiers below it, lowest first.
    $tiers = [Catzc.Base.Timeouts.TestTiers]::Names
    $excludeTags = [System.Collections.Generic.List[string]]::new()
    for ($level = $tiers.Count - 1; $level -gt $MaxLevel; $level--) {
        $excludeTags.Add($tiers[$level])
    }
    for ($level = 0; $level -lt $MinLevel; $level++) {
        $excludeTags.Add($tiers[$level])
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
