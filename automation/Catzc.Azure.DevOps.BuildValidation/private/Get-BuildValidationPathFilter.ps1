<#
.SYNOPSIS
    The ADO branch-policy path filters for a globset — its native trigger projection, anchored with '/'.
.DESCRIPTION
    The single place the build-validation policy's `filenamePatterns` is derived (used by both Register- and...
    [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md),
    [ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)
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
