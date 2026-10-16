<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestDiscovery.ps1
    folder: private
    name: get-test-discovery
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1
  config:
    synopsis: Runs a discovery-only Pester pass over the given test paths and returns the result.
    description: |-
      The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations
      (the mandatory tier/category check) and Split-TestAutomationFiles (the phase split) both consume the one
      result, so the tree is discovered once per run, not once per question. Run.SkipRun makes it inspect every
      test regardless of tag filters — nothing executes. A Go test folder is discovered through the Go bridge
      (ConvertTo-PesterRunTarget), which reads its Go tests from the source without running go. Pester must already
      be loaded (Test-Automation lazy-loads it before calling this).
    parameters:
      TestPath: One or more 'tests' folders, or Go test folders, to discover.
    outputs: The Pester run object of the discovery pass (every discovered test, none run).
---
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
