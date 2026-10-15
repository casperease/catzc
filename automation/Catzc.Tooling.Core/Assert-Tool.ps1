<#
.SYNOPSIS
    Asserts that a tool is installed and at the expected version.
.DESCRIPTION
    Checks that the tool's command is on PATH and that its version matches the locked version in tools.yml (outside a...
    [comment:1](/docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.PARAMETER SkipVersionCheck
    Only assert the tool is on PATH.
    [comment:2](/docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md#comment2)
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

    # A tool with declared candidate paths is located by the probe, never by its bare name on PATH (for bash on...
    # [comment:3](/docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md#comment3)
    if ($config.HasProbes()) {
        $probe = Resolve-ToolExecutable -Tool $Tool
        $remedy = if (Get-Command "Install-$command" -ErrorAction Ignore) {
            " Run Install-$command."
        }
        else {
            ''
        }
        if (-not $probe.Found) {
            throw "$Tool is not installed ($($config.command) not found at its candidate paths or on PATH).$remedy"
        }
        if (-not $SkipVersionCheck -and -not $probe.VersionOk) {
            throw "$Tool version mismatch: expected $($probe.Required).x, found $($probe.Version ?? 'an unreadable version') at '$($probe.Path)'.$remedy"
        }
        return
    }

    Assert-Command $config.command -ErrorText "$Tool is not installed ($($config.command) not found on PATH). Run Install-$command."

    if (-not $SkipVersionCheck) {
        Assert-ToolVersion -Tool $Tool
    }
}
