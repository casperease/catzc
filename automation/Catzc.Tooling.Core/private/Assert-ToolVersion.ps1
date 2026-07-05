<#
.SYNOPSIS
    Asserts the installed version of a tool matches its locked version.
.DESCRIPTION
    Checks once per session and caches the result. Subsequent calls
    for the same tool return immediately.

    Devbox lever: a tool may declare an optional `devbox_version` in tools.yml. OUTSIDE a CI pipeline
    (Test-IsRunningInPipeline is false) an installed version matching EITHER the locked `version` or the
    `devbox_version` prefix is accepted, so a devbox can run a functional off-pin tool for local pre-commit
    tooling. A pipeline session ignores the lever and enforces the locked `version` alone, keeping
    main/master builds deterministically locked.
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
    if (-not $script:toolVersionCache) {
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

    # Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version
    # lever from tools.yml. Read from the raw config — devbox_version is a version-check policy field, not part
    # of the typed ToolConfig install mirror. A pipeline enforces the locked version alone.
    $accepted = [System.Collections.Generic.List[string]]::new()
    $accepted.Add($config.version)
    if (-not (Test-IsRunningInPipeline)) {
        $devboxVersion = (Get-Config -Config tools)[$Tool]['devbox_version']
        if ($devboxVersion) {
            $accepted.Add($devboxVersion)
        }
    }

    $matched = $accepted | Where-Object { $installed.StartsWith($_) } | Select-Object -First 1
    if (-not $matched) {
        $location = (Get-Command $config.command).Source
        throw "$Tool version mismatch: expected $($config.version).x, found $installed at '$location'. Run Install-$command or uninstall the conflicting version."
    }

    Write-Verbose "$Tool version $installed verified"
    $script:toolVersionCache[$Tool] = $true
}
