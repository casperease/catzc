<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestDiscovery.ps1.md"
  header: "generated"
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
