<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestCategoryTag.ps1.md"
  header: "generated"
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
