<#
---
catzc:
  immutable:
    with_body_sha: "398e4e671f2f"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
    docs: "[Get-TestExcludeTag.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestExcludeTag.ps1.md)"
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
