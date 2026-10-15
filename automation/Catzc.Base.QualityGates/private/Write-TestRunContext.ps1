<#
.SYNOPSIS
    Prints a test run's context block under its banner: one line per fact.
.DESCRIPTION
    Renders Get-TestRunContext's record so a reader sees, before any test output, what the run is and where it runs —...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestRunContext.ps1.md#comment1)
.PARAMETER Context
    The record Get-TestRunContext returned.
.EXAMPLE
    Write-TestRunContext -Context $context
#>
function Write-TestRunContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Context
    )

    $location = $Context.location
    if ($Context.locationReason) {
        $location += " ($($Context.locationReason))"
    }
    $tiers = "asked $($Context.tiersRequested) · running $($Context.tiersRunning)"
    if ($Context.tierCap) {
        $tiers += " — $($Context.tierCap)"
    }
    $tools = @($Context.tools.Keys | ForEach-Object {
            $state = if ($Context.tools[$_]) {
                'yes'
            }
            else {
                'no'
            }
            "$_ $state"
        }) -join ' · '

    $lines = [ordered]@{
        'entry point' = "$($Context.entryPoint) · $($Context.run) run · code root $($Context.codeRoot)"
        'location'    = $location
        'tiers'       = $tiers
        'actor'       = $Context.actor
        'tools'       = $tools
        'selection'   = $Context.selection
    }
    foreach ($label in $lines.Keys) {
        Write-Message ('  {0,-12} {1}' -f $label, $lines[$label]) -NoHeader
    }
}
