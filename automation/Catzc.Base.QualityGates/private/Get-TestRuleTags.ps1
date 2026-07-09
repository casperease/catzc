<#
.SYNOPSIS
    The set of ADR rule citations a Pester test enforces — every 'ADR-<CODE>#<n>' tag on the test and its
    ancestor blocks, unioned.
.DESCRIPTION
    The optional third tag dimension (provenance): which ADR rule(s) a test enforces, cited in the
    docs/adr/index.md '#' form (e.g. 'ADR-AUTO-ERROR#3'). Unlike the tier and category axes — single-valued and
    resolved nearest-contributing-block-wins (Get-TestBlockTag) — provenance is SET-VALUED and ADDITIVE: a
    Describe may enforce a broad rule and an inner It a specific one, and both hold. So this UNIONS every
    well-formed citation across the test's own It-tags and every ancestor block (root excluded), returning them
    distinct and sorted. Only strictly well-formed 'ADR-<CODE>#<n>' citations contribute; a malformed one is
    left for Get-TestTagViolations to reject rather than silently entering a coverage row. See the
    test-automation ADR.
.PARAMETER Test
    A Pester test object (a discovery-pass test, or an item of $result.Tests). Its .Tag and .Block chain carry
    the tags.
.OUTPUTS
    [string[]] the distinct citations (e.g. 'ADR-AUTO-ERROR#3'), ordinally sorted (empty when none).
#>
function Get-TestRuleTags {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    # The tag levels to union: the test's own It-tags, then each ancestor block (root excluded) — the same walk
    # Get-TestBlockTag makes, but accumulating across every level instead of stopping at the first that
    # contributes, because provenance is a set (a Describe rule and an inner It rule both hold).
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
            # Strict, case-sensitive citation grammar: only a well-formed 'ADR-<CODE>#<n>' contributes. A
            # miscased or malformed tag is Get-TestTagViolations' concern, not a coverage row's.
            if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
