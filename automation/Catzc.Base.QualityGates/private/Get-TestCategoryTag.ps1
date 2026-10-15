<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestCategoryTag.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Resolves a Pester test's category (logic/integrity) from its block hierarchy.
.DESCRIPTION
    Null means no category tag or two in the nearest block; both are tagging violations, and the tag has no default.
.PARAMETER Test
    A Pester test-result object (an item of $result.Tests). Its .Block chain carries the category tags.
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
