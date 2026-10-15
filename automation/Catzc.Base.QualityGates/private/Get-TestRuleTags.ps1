<#
.SYNOPSIS
    The set of ADR rule citations a Pester test enforces — every 'ADR-<CODE>#<n>' tag on the test and its
    ancestor blocks, unioned.
.DESCRIPTION
    The optional third tag dimension (provenance): which ADR rule(s) a test enforces, cited in the '#' form (e.g.
    [ADR-PWSH-ERROR#3](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment1)
.PARAMETER Test
    A Pester test object (a discovery-pass test, or an item of $result.Tests).
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

    # The tag levels to union: the test's own It-tags, then each ancestor block (root excluded) — the same walk...
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
            # Strict, case-sensitive citation grammar: only a well-formed 'ADR-<CODE>#<n>' contributes.
            # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md#comment4)
            if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
