<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Test-CompletesWithin.ps1
    kind: function
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
    [comment:1](/docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md#comment1)
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Budget
    While the budget is exempt, the default limit becomes the exemption ceiling, not the normal pwsh limit.
    [comment:2](/docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md#comment2)
.PARAMETER Seconds
    Left unset, the limit comes from timeouts.yml for this environment, or from the budget's exemption ceiling.
    [comment:3](/docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md#comment3)
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
