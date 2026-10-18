<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Test-Tool.ps1
    name: test-tool
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Test-Tool.Tests.ps1
---
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
        if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {
            return $installed.StartsWith($config.devbox_version)
        }
        return $false
    }

    $true
}
