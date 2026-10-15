<#
.SYNOPSIS
    Tests whether a tool is installed at the expected version.
.DESCRIPTION
    Returns $true if the tool's command exists, its version command produces parseable output, AND the installed...
    [comment:1](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER SkipVersionCheck
    Only test the tool is on PATH and functional.
    [comment:2](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment2)
.PARAMETER PassThru
    Return the probe record (Catzc.Base.Execution.ExecutableProbe: Name, Found, Path, Method, Version, Required,...
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
        # Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version matching...
        # [comment:4](/docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md#comment4)
        if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {
            return $installed.StartsWith($config.devbox_version)
        }
        return $false
    }

    $true
}
