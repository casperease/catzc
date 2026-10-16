<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestLevelTag.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestLevelTag.Tests.ps1
  config:
    synopsis: Resolves a Pester test's integration tier (L0 to L4, [Catzc.Base.Timeouts.TestTiers]) from its block hierarchy.
    description: |-
      Returns the single tier tag for a test — nearest contributing block wins (innermost override). Returns
      $null when no block in the chain carries a tier tag, or when the nearest contributing block carries more
      than one (ambiguous); both are tagging violations surfaced by Get-TestTagViolations. The tier tag is
      mandatory — there is no default (see the test-automation ADR). Shares the block walk with
      Get-TestCategoryTag via Get-TestBlockTag, and feeds Test-Automation's timing report and
      Write-TestAutomationReport.
    parameters:
      Test: A Pester test-result object (an item of $result.Tests). Its .Block chain carries the tier tags.
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
