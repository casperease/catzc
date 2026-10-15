<#
.SYNOPSIS
    Tests whether a script block finishes within a time limit; past it the work is stopped.
.DESCRIPTION
    The boolean form of Assert-CompletesWithin: $true when the block finished in time, $false when the safeguard...
    [comment:1](/docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md#comment1)
.PARAMETER ScriptBlock
    The work to time.
.PARAMETER Budget
    The work's immutable budget GUID.
    [comment:2](/docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md#comment2)
.PARAMETER Seconds
    The limit in seconds.
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
