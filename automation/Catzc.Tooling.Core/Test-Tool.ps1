<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Test-Tool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether a tool is installed at the expected version.
.DESCRIPTION
    A tool with declared candidate paths is found by the executable probe, which starts no process; others by PATH name.
    [comment:1](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER SkipVersionCheck
    A parseable version is still needed, so a Store stub fails, but a version that is not the locked one passes.
    [comment:2](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment2)
.PARAMETER PassThru
    The record works for any tool, probed or not, and carries the timings and actor that Write-ToolProbeReport shows.
    [comment:3](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment3)
.EXAMPLE
    Test-Tool 'python'
.EXAMPLE
    Test-Tool 'python' -SkipVersionCheck
.EXAMPLE
    Test-Tool 'bash' -PassThru | Write-ToolProbeReport
#>
function Test-Tool {
    [OutputType([bool], [Catzc.Base.Execution.ExecutableProbe])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [switch] $SkipVersionCheck,
        [switch] $PassThru
    )

    $config = Get-ToolConfig -Tool $Tool

    if ($PassThru -or $config.HasProbes()) {
        $probe = Resolve-ToolExecutable -Tool $Tool
        if ($PassThru) {
            return $probe
        }
        if ($SkipVersionCheck) {
            return $probe.Found -and [bool]$probe.Version
        }
        return $probe.VersionOk
    }

    if (-not (Test-Command $config.command)) {
        return $false
    }

    $installed = Get-ToolVersion -Config $config
    if ($null -eq $installed) {
        return $false
    }

    if (-not $SkipVersionCheck) {
        if ($installed.StartsWith($config.version)) {
            return $true
        }
        # Mirrors Assert-ToolVersion, so a levered off-pin tool also passes the quality gates, not only asserts.
        # [comment:4](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment4)
        if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {
            return $installed.StartsWith($config.devbox_version)
        }
        return $false
    }

    $true
}
