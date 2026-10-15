<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Extracts the human-readable reason a Pester test was skipped.
.DESCRIPTION
    A skip with no reason records no error at all, so it reads 'no reason given'; any other message passes verbatim.
.PARAMETER Test
    A Pester test-result object (an item of $result.Tests). Its .ErrorRecord carries the skip message.
#>
function Get-TestSkipReason {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    $records = @($Test.ErrorRecord)
    if ($records.Count -eq 0) {
        return 'no reason given'
    }   # an `It -Skip` discovery skip records nothing

    $message = "$($records[-1].Exception.Message)".Trim()

    # Capture $Matches at once: the next -match clobbers it, and the reason follows "because".
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md#comment2)
    if ($message -match 'because\s+(.+?)\s*$') {
        $found = $Matches[1]
        return $found
    }

    # "is skipped" with no -Because gives no reason; anything else (a framework skip message) is the reason.
    if ([string]::IsNullOrWhiteSpace($message) -or $message -eq 'is skipped') {
        return 'no reason given'
    }
    $message
}
