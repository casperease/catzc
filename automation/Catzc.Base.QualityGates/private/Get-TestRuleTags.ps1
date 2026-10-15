<#
.SYNOPSIS
    The set of ADR rule citations a Pester test enforces — every 'ADR-<CODE>#<n>' tag on the test and its
    ancestor blocks, unioned.
.DESCRIPTION
    Provenance is a set, not nearest-wins like tier and category: a Describe rule and an inner It rule both hold.
    [ADR-PWSH-ERROR#3](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment1)
.PARAMETER Test
    Pass the whole test object: the tags sit on .Tag and up the .Block chain, not on the test alone.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment2)
.OUTPUTS
    [string[]] the distinct citations (e.g. 'ADR-PWSH-ERROR#3'), ordinally sorted (empty when none).
#>
function Get-TestRuleTags {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    # Unlike Get-TestBlockTag, the walk does not stop at the first level that contributes: every level adds to the set.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment3)
    $levels = [System.Collections.Generic.List[object]]::new()
    $levels.Add($Test.Tag)
    $block = $Test.Block
    while ($block -and -not $block.IsRoot) {
        $levels.Add($block.Tag)
        $block = $block.Parent
    }

    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($levelTags in $levels) {
        foreach ($tag in $levelTags) {
            # A miscased or malformed tag is skipped here: Get-TestTagViolations rejects it, never a coverage row.
            # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment4)
            if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
