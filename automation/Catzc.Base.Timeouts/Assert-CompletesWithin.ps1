<#
.SYNOPSIS
    Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.
.DESCRIPTION
    The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass
    (it finished in time) or throw (it was stopped at the limit, or it failed on its own).
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Seconds
    The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml (Get-TimeoutSeconds).
.PARAMETER Activity
    What the work is, for the timeout message. Defaults to the script block's text.
.EXAMPLE
    Assert-CompletesWithin { Import-Widget } -Seconds 2
#>
function Assert-CompletesWithin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds -Activity $Activity
}
