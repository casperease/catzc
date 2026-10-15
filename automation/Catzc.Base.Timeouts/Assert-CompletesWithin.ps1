<#
.SYNOPSIS
    Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.
.DESCRIPTION
    The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass (it...
    [comment:1](/docs/references/automation/catzc-base-timeouts/Assert-CompletesWithin.ps1.md#comment1)
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Budget
    The work's immutable budget GUID.
    [comment:2](/docs/references/automation/catzc-base-timeouts/Assert-CompletesWithin.ps1.md#comment2)
.PARAMETER Seconds
    The limit in seconds.
    [comment:3](/docs/references/automation/catzc-base-timeouts/Assert-CompletesWithin.ps1.md#comment3)
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

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds -Activity $Activity
}
