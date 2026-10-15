<#
.SYNOPSIS
    Extracts the human-readable reason a Pester test was skipped.
.DESCRIPTION
    A test skipped with `Set-ItResult -Skipped -Because '<reason>'` carries an error record whose message reads "is...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md#comment1)
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

    # Set-ItResult renders "is skipped, because <reason>" — pull out the reason.
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
