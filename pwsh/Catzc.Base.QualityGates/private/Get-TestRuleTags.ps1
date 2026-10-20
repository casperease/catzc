<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
    folder: private
    name: get-test-rule-tags
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
    docs: "[Get-TestRuleTags.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md)"
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

    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($levelTags in $levels) {
        foreach ($tag in $levelTags) {
            if ($tag -cmatch '^ADR(?:-[A-Z][A-Z0-9]*){3,}$') {
                [void]$ids.Add($tag)
            }
        }
    }

    , @($ids | Sort-Object)
}
