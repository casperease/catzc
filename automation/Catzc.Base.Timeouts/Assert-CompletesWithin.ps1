<#
.SYNOPSIS
    Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.
.DESCRIPTION
    The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass
    (it finished in time) or throw (it was stopped at the limit, or it failed on its own).
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Budget
    The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
    ceiling instead.
.PARAMETER Seconds
    The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
    ceiling (Get-TimeoutSeconds -Budget).
.PARAMETER Activity
    What the work is, for the timeout message. Defaults to the script block's text.
.EXAMPLE
    Assert-CompletesWithin { Import-Widget } -Seconds 2
.EXAMPLE
    Assert-CompletesWithin { Sync-Widget } -Budget $widgetSyncBudget
#>
function Assert-CompletesWithin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [string] $Budget,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds -Activity $Activity
}
