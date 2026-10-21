<#
---
catzc:
  immutable:
    with_body_sha: "78565f5701d8"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
    docs: "[Get-TestRuleTags.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-TestRuleTags.ps1.md)"
    cites:
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
---
#>

function Get-TestRuleTags {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    $levels = [System.Collections.Generic.List[object]]::new()
    $levels.Add($Test.Tag)
    $block = $Test.Block
    while ($block -and -not $block.IsRoot) {
        $levels.Add($block.Tag)
        $block = $block.Parent
    }

    $form = (Get-Config -Config adrs).CodeForm
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($levelTags in $levels) {
        foreach ($tag in $levelTags) {
            if ($form.IsRule($tag)) {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
