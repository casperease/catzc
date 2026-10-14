<#
.SYNOPSIS
    Tests whether a tool is installed at the expected version.
.DESCRIPTION
    Returns $true if the tool's command exists on PATH, its version
    command produces parseable output, AND the installed version matches
    the locked version in tools.yml. Returns $false for missing tools,
    Windows Store stubs, broken installations, and version mismatches.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER SkipVersionCheck
    Only test the tool is on PATH and functional. Skip the version match.
    Use for operations that need presence but not a specific version
    (e.g., uninstalling).
.EXAMPLE
    Test-Tool 'python'
.EXAMPLE
    Test-Tool 'python' -SkipVersionCheck
#>
function Test-Tool {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [switch] $SkipVersionCheck
    )

    $config = Get-ToolConfig -Tool $Tool

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
        # Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version
        # matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for quality gates
        # too — not just runtime asserts.
        if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {
            return $installed.StartsWith($config.devbox_version)
        }
        return $false
    }

    $true
}
