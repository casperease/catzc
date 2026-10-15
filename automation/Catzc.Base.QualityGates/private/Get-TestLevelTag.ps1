<#
.SYNOPSIS
    Resolves a Pester test's integration tier (L0 to L4, [Catzc.Base.Timeouts.TestTiers]) from its block hierarchy.
.DESCRIPTION
    Null means no tier tag, or several in the nearest block; Get-TestTagViolations reports both, there is no default.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestLevelTag.ps1.md#comment1)
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
