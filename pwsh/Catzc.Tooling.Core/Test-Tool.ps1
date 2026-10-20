<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Test-Tool.ps1
    name: test-tool
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Test-Tool.Tests.ps1
    docs: "[Test-Tool.ps1.md](docs/references/pwsh/catzc-tooling-core/Test-Tool.ps1.md)"
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
