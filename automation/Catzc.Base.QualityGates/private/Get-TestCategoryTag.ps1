<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-TestCategoryTag.ps1
    folder: private
    name: get-test-category-tag
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
    test: automation/Catzc.Base.QualityGates/tests/Get-TestCategoryTag.Tests.ps1
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
