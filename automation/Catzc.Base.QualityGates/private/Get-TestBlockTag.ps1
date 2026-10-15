<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Resolves the tags of one axis for a Pester test — nearest contributing block wins.
.DESCRIPTION
    Two returned tags mean one block carries two tags of the axis, which callers treat as a tagging violation.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md#comment1)
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

    # The -eq match ignores case, so the canonical casing from Valid is returned, not the casing written on the test.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md#comment2)
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
