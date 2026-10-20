<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestCategoryTag.ps1
    folder: private
    name: get-test-category-tag
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestCategoryTag.Tests.ps1
    docs: "[Get-TestCategoryTag.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestCategoryTag.ps1.md)"
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
