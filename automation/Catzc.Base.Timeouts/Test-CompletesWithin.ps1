<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Test-CompletesWithin.ps1
    kind: gate-function
    module: Catzc.Base.Timeouts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether a script block finishes within a time limit; past it the work is stopped.
.DESCRIPTION
    Answers was it fast enough, never did it succeed: an error the block raises on its own still throws.
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Budget
    While the budget is exempt, the default limit becomes the exemption ceiling, not the normal pwsh limit.
.PARAMETER Seconds
    Left unset, the limit comes from timeouts.yml for this environment, or from the budget's exemption ceiling.
.EXAMPLE
    if (-not (Test-CompletesWithin { Get-Widget } -Seconds 2)) { Write-Message 'widget lookup is slow' }
#>
function Test-CompletesWithin {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget)
    )

    try {
        $null = Invoke-WithTimeout $ScriptBlock -Seconds $Seconds
        $true
    }
    catch [System.TimeoutException] {
        $false
    }
}
