<#
---
catzc:
  immutable:
    with_body_sha: "3b9486d31568"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestCategoryTag.Tests.ps1
    docs: "[Get-TestCategoryTag.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestCategoryTag.ps1.md)"
---
#>

function Get-TestCategoryTag {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    $categoryTags = Get-TestBlockTag -Test $Test -Valid 'logic', 'integrity'
    if ($categoryTags.Count -eq 1) {
        $categoryTags[0]
    }
    else {
        $null
    }
}
