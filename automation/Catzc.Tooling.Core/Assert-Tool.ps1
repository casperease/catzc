<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Assert-Tool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a tool is installed and at the expected version.
.DESCRIPTION
    DependsOn is not checked: those are install-time needs, and a probed tool is found by its candidate paths first.
    [comment:1](/docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.PARAMETER SkipVersionCheck
    A wrong version still passes, so use it where presence is enough, such as before an uninstall.
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

    # Bare-name lookup is wrong here: on Windows the name bash can resolve to the WSL launcher, not the tool.
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
