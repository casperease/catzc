<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestLevelTag.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Resolves a Pester test's integration tier (L0 to L4, [Catzc.Base.Timeouts.TestTiers]) from its block hierarchy.
.DESCRIPTION
    Null means no tier tag, or several in the nearest block; Get-TestTagViolations reports both, there is no default.
.PARAMETER Test
    A Pester test-result object (an item of $result.Tests). Its .Block chain carries the tier tags.
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
