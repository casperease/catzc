<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/private/Assert-ToolVersion.ps1
    folder: private
    name: assert-tool-version
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
    cites:
      - ADR-PWSH-CACHE#4
---
#>

function Assert-ToolVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    # Cached for session lifetime. Reset by reimporting (.\importer.ps1).
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:toolVersionCache')) {
        $script:toolVersionCache = @{}
    }

    if ($script:toolVersionCache[$Tool]) {
        Write-Verbose "Version check cached for $Tool — skipping"
        return
    }

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool
    $installed = Get-ToolVersion -Config $config

    if (-not $installed) {
        throw "$Tool is not functional — '$($config.version_command)' did not return a valid version. Run Install-$command."
    }

    $accepted = [System.Collections.Generic.List[string]]::new()
    $accepted.Add($config.version)
    if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {
        $accepted.Add($config.devbox_version)
    }

    $matched = $accepted | Where-Object { $installed.StartsWith($_) } | Select-Object -First 1
    if (-not $matched) {
        $location = (Get-Command $config.command).Source
        throw "$Tool version mismatch: expected $($config.version).x, found $installed at '$location'. Run Install-$command or uninstall the conflicting version."
    }

    Write-Verbose "$Tool version $installed verified"
    $script:toolVersionCache[$Tool] = $true
}
