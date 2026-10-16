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
  config:
    synopsis: Tests whether a tool is installed at the expected version.
    description: |-
      Returns $true if the tool's command exists, its version command produces parseable output, AND the installed
      version matches the locked version in tools.yml. Returns $false for missing tools, Windows Store stubs, broken
      installations, and version mismatches.

      A tool whose entry declares candidate paths (windows_probes, unix_probes and their pipeline lists, or
      probe_excludes) is located by the executable probe (Resolve-ToolExecutable, in Catzc.Base.Execution): the
      candidates for this platform and run environment first, then PATH, with no process start; its version runs once
      per executable per session. Any other tool is checked by its command name on PATH.
    parameters:
      Tool: The snake_case tool key as defined in tools.yml.
      SkipVersionCheck: |-
        Only test the tool is on PATH and functional. Skip the version match.
        Use for operations that need presence but not a specific version
        (e.g., uninstalling).
      PassThru: |-
        Return the probe record (Catzc.Base.Execution.ExecutableProbe: Name, Found, Path, Method, Version, Required,
        VersionOk, ProbeMs, VersionMs, Actor) instead of a boolean, for any tool. Write-ToolProbeReport renders it.
    examples:
      - Test-Tool 'python'
      - Test-Tool 'python' -SkipVersionCheck
      - Test-Tool 'bash' -PassThru | Write-ToolProbeReport
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
