<#
.SYNOPSIS
    Runs a discovery-only Pester pass over the given test paths and returns the result.
.DESCRIPTION
    The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations (the...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestDiscovery.ps1.md#comment1)
.PARAMETER TestPath
    One or more 'tests' folders, or Go test folders, to discover.
.OUTPUTS
    The Pester run object of the discovery pass (every discovered test, none run).
#>
function Get-TestDiscovery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $target = ConvertTo-PesterRunTarget -Path $TestPath
    $config = New-PesterConfiguration
    if ($target.Path.Count -gt 0) {
        $config.Run.Path = $target.Path
    }
    if ($target.Container.Count -gt 0) {
        $config.Run.Container = $target.Container
    }
    $config.Run.SkipRun = $true
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'None'
    Invoke-Pester -Configuration $config
}
