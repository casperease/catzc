<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestSkipReason.ps1.md"
  header: "generated"
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
