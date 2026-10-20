<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestLevelTag.ps1
    folder: private
    name: get-test-level-tag
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestLevelTag.Tests.ps1
    docs: "[Get-TestLevelTag.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestLevelTag.ps1.md)"
---
#>

function Get-TestLevelTag {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    $tierTags = Get-TestBlockTag -Test $Test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
    if ($tierTags.Count -eq 1) {
        $tierTags[0]
    }
    else {
        $null
    }
}
