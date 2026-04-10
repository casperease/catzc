<#
.SYNOPSIS
    Resolves the tags of one axis for a Pester test — nearest contributing block wins.
.DESCRIPTION
    Returns the matching tags from the FIRST level that carries any tag of the axis: the test's own It-tags,
    else the innermost ancestor block (root excluded). This is the innermost-override model Pester itself uses
    for tag filtering — an inner block's tag wins over an outer default, and outer blocks are ignored once a
    nearer one contributes. Normally one tag; two means a single block carries two tags of the same axis
    (ambiguous), which callers treat as a tagging violation. Always returns an array (empty when nothing
    matches). Shared by Get-TestLevelTag (tier) and Get-TestCategoryTag (category) so the resolution logic has
    one home.
.PARAMETER Test
    A Pester test object (an item of $result.Tests). Its .Tag and .Block chain carry the tags.
.PARAMETER Valid
    The axis's valid tags in canonical casing (e.g. 'L0','L1','L2','L3' or 'logic','integrity').
#>
function Get-TestBlockTag {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Test,

        [Parameter(Mandatory)]
        [string[]] $Valid
    )

    # The tag levels to check, nearest first: the test's own It-tags, then each ancestor block (root excluded).
    $levels = [System.Collections.Generic.List[object]]::new()
    $levels.Add($Test.Tag)
    $block = $Test.Block
    while ($block -and -not $block.IsRoot) {
        $levels.Add($block.Tag)
        $block = $block.Parent
    }

    # The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
    # case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
    foreach ($levelTags in $levels) {
        $ret = @(
            foreach ($tag in $levelTags) {
                foreach ($validTag in $Valid) {
                    if ($validTag -eq $tag) {
                        $validTag
                    }
                }
            }
        )
        if ($ret.Count) {
            return , $ret
        }
    }

    , @()
}
