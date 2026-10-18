<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Assert-Tool.ps1
    name: assert-tool
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
---
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
