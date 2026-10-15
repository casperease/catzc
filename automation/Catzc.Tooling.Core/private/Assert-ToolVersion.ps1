<#
.SYNOPSIS
    Asserts the installed version of a tool matches its locked version.
.DESCRIPTION
    Checks once per session and caches the result.
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
#>
function Assert-ToolVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    # Cached for session lifetime. Reset by reimporting (.\importer.ps1).
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:toolVersionCache')) {
        # strict-clean probe of the lazy cache entry
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:2](/docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md#comment2)
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

    # Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version lever...
    # [comment:3](/docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md#comment3)
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
