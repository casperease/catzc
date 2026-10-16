<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1
    folder: private
    name: get-test-block-tag
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
  config:
    synopsis: Resolves the tags of one axis for a Pester test — nearest contributing block wins.
    description: |-
      Returns the matching tags from the FIRST level that carries any tag of the axis: the test's own It-tags,
      else the innermost ancestor block (root excluded). This is the innermost-override model Pester itself uses
      for tag filtering — an inner block's tag wins over an outer default, and outer blocks are ignored once a
      nearer one contributes. Normally one tag; two means a single block carries two tags of the same axis
      (ambiguous), which callers treat as a tagging violation. Always returns an array (empty when nothing
      matches). Shared by Get-TestLevelTag (tier) and Get-TestCategoryTag (category) so the resolution logic has
      one home.
    parameters:
      Test: A Pester test object (an item of $result.Tests). Its .Tag and .Block chain carry the tags.
      Valid: The axis's valid tags in canonical casing (e.g. 'L0','L1','L2','L3' or 'logic','integrity').
---
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
