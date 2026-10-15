<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Extracts the human-readable reason a Pester test was skipped.
    description: |-
      A test skipped with `Set-ItResult -Skipped -Because '<reason>'` carries an error record whose message
      reads "is skipped, because <reason>"; this returns just "<reason>". A skip with no -Because (a bare
      `Set-ItResult -Skipped`, or an `It -Skip`, which records no error at all) has no reason, so the function
      returns 'no reason given'. Any other recorded message (e.g. Run.SkipRemainingOnFailure's "Skipped due to
      previous failure at …") is returned verbatim. Feeds Write-TestAutomationSkipReport.
    parameters:
      Test: A Pester test-result object (an item of $result.Tests). Its .ErrorRecord carries the skip message.
---
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
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md#comment3)
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
