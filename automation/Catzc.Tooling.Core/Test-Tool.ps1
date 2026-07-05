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
        # matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for test gates
        # too — not just runtime asserts. Read from the raw config: devbox_version is a version-check policy
        # field, not part of the typed ToolConfig install mirror.
        $devboxVersion = (Get-Config -Config tools)[$Tool]['devbox_version']
        if ($devboxVersion -and -not (Test-IsRunningInPipeline)) {
            return $installed.StartsWith($devboxVersion)
        }
        return $false
    }

    $true
}
