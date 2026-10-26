<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestRuleTags.ps1.md"
  header: "generated"
---
#>

function Get-TestRuleTags {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    # Get-TestBlockTag's walk, but unioned across every level rather than stopping at the first.
    $levels = [System.Collections.Generic.List[object]]::new()
    $levels.Add($Test.Tag)
    $block = $Test.Block
    while ($block -and -not $block.IsRoot) {
        $levels.Add($block.Tag)
        $block = $block.Parent
    }

    $form = (Get-Config -Config drs).CodeForm
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($levelTags in $levels) {
        foreach ($tag in $levelTags) {
            # Only a well-formed code counts; a malformed tag is Get-TestTagViolations' concern.
            if ($form.IsRule($tag)) {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
