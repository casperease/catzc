<#
---
catzc:
  immutable:
    with_body_sha: c6f480019f57
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
