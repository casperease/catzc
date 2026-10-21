<#
---
catzc:
  immutable:
    with_body_sha: "60bd94a4ce80"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1
    docs: "[Get-TestDiscovery.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestDiscovery.ps1.md)"
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
