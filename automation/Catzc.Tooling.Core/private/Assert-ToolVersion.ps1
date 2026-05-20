<#
.SYNOPSIS
    Asserts the installed version of a tool matches its locked version.
.DESCRIPTION
    Checks once per session and caches the result. Subsequent calls
    for the same tool return immediately.
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

    if (-not $installed.StartsWith($config.version)) {
        $location = (Get-Command $config.command).Source
        throw "$Tool version mismatch: expected $($config.version).x, found $installed at '$location'. Run Install-$command or uninstall the conflicting version."
    }

    Write-Verbose "$Tool version $installed verified"
    $script:toolVersionCache[$Tool] = $true
}
