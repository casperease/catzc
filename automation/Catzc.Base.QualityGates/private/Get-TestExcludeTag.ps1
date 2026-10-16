<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestExcludeTag.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
  config:
    synopsis: |-
      Computes the Pester ExcludeTag list for a tier range + category — shared by Test-Automation and
      Test-InIsolation so the tier/category filter has one definition.
    description: |-
      Excludes every tier tag outside [MinLevel, MaxLevel] and, when -Category is Logic or Integrity, the OTHER
      category's tag. ExcludeTag values are lowercase to match the test files' actual tags ('logic'/'integrity');
      tier tags are [Catzc.Base.Timeouts.TestTiers]::Names ('L0'..'L4'). A mixed file's per-Context category tags
      filter correctly because ExcludeTag matches an item's own tag.
    parameters:
      MinLevel: Lowest tier to keep (0-4). Tiers below it are excluded.
      MaxLevel: Highest tier to keep (0-4). Tiers above it are excluded.
      Category: Logic (exclude integrity), Integrity (exclude logic), or Both (exclude neither).
    examples:
      - 'Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic   # -> L2, L3, integrity'
---
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
