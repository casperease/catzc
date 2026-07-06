<#
.SYNOPSIS
    Runs a discovery-only Pester pass over the given test folders and returns the result.
.DESCRIPTION
    The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations
    (the mandatory tier/category gate) and Split-TestAutomationFiles (the phase split) both consume the one
    result, so the tree is discovered once per run, not once per question. Run.SkipRun makes it inspect every
    test regardless of tag filters — nothing executes. Pester must already be loaded (Test-Automation
    lazy-loads it before calling this).
.PARAMETER TestPath
    One or more 'tests' folders to discover.
.OUTPUTS
    The Pester run object of the discovery pass (every discovered test, none run).
#>
function Get-TestDiscovery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $config = New-PesterConfiguration
    $config.Run.Path = $TestPath
    $config.Run.SkipRun = $true
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'None'
    Invoke-Pester -Configuration $config
}
