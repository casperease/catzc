<#
---
catzc:
  immutable:
    with_body_sha: "3faee148d147"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
    docs: "[Get-TestBlockTag.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-TestBlockTag.ps1.md)"
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
