<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Assert-Tool.ps1
    kind: function
    subkind: assert
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Core
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md
      test: automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
  config:
    synopsis: Asserts that a tool is installed and at the expected version.
    description: |-
      Checks that the tool's command is on PATH and that its version
      matches the locked version in tools.yml (outside a CI pipeline an optional
      devbox_version lever also passes — see Assert-ToolVersion). Does NOT check
      DependsOn — those are install-time dependencies, not runtime requirements.
      A tool whose entry declares candidate paths is located by the executable probe instead
      (Resolve-ToolExecutable): its candidates for this platform and run environment, then PATH.
    parameters:
      Tool: The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
      SkipVersionCheck: |-
        Only assert the tool is on PATH. Skip the version match.
        Use for operations that need presence but not a specific version
        (e.g., uninstalling).
    examples:
      - Assert-Tool 'python'
      - Assert-Tool 'poetry'
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
