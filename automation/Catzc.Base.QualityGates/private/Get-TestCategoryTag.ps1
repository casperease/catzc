<#
.SYNOPSIS
    Resolves a Pester test's category (logic/integrity) from its block hierarchy.
.DESCRIPTION
    Returns the single category tag for a test — nearest contributing block wins (innermost override).
    Returns $null when no block in the chain carries a category tag, or when the nearest contributing block
    carries both (ambiguous); both are tagging violations surfaced by Get-TestTagViolations. A logic test
    verifies a function's logic on mocks/own fixtures, independent of shipped config; an integrity test
    verifies the actual repository contents (shipped configs, templates, binaries, conventions, dependency
    graphs). The category tag is mandatory — there is no default (see the test-automation ADR). Shares the
    block walk with Get-TestLevelTag via Get-TestBlockTag.
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
