<#
.SYNOPSIS
    Asserts that a tool is installed and at the expected version.
.DESCRIPTION
    Checks that the tool's command is on PATH and that its version
    matches the locked version in tools.yml (outside a CI pipeline an optional
    devbox_version lever also passes — see Assert-ToolVersion). Does NOT check
    DependsOn — those are install-time dependencies, not runtime requirements.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.PARAMETER SkipVersionCheck
    Only assert the tool is on PATH. Skip the version match.
    Use for operations that need presence but not a specific version
    (e.g., uninstalling).
.EXAMPLE
    Assert-Tool 'python'
.EXAMPLE
    Assert-Tool 'poetry'
#>
function Assert-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [switch] $SkipVersionCheck
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool

    Assert-Command $config.command -ErrorText "$Tool is not installed ($($config.command) not found on PATH). Run Install-$command."

    if (-not $SkipVersionCheck) {
        Assert-ToolVersion -Tool $Tool
    }
}
