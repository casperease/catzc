<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
    kind: function
    module: Catzc.Azure.DevOps.BuildValidation
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE#4
---
#>

<#
.SYNOPSIS
    The ADO branch-policy path filters for a globset — its native trigger projection, anchored with '/'.
.DESCRIPTION
    Register and Unregister share this, so the created filter and the match-to-remove filter can never drift apart.
    [comment:1](/docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md#comment1)
.PARAMETER GlobSet
    The globset to project.
.OUTPUTS
    [string[]] The '/'-anchored path filters, in projection order.
#>
function Get-BuildValidationPathFilter {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $trigger = Get-GlobSetTrigger -GlobSet $GlobSet
    [string[]] @(foreach ($pattern in $trigger.GitHub) {
            if ($pattern.StartsWith('!')) {
                '!/' + $pattern.Substring(1)
            }
            else {
                '/' + $pattern
            }
        })
}
