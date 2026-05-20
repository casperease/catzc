<#
.SYNOPSIS
    Returns the locked configuration for a CLI tool as a validated ToolConfig.
.DESCRIPTION
    Binds one tool's locked definition from configs/tools.yml (loaded and cached for the session via
    Get-Config) to a Catzc.Tooling.Core.ToolConfig — the ctor validates the required keys. The bound
    object is memoized by the config entry's identity, so repeated calls return the same instance; when
    the config cache is reset the entry object is new, so a fresh ToolConfig is built.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.EXAMPLE
    $config = Get-ToolConfig -Tool 'python'
#>
function Get-ToolConfig {
    [CmdletBinding()]
    [OutputType([Catzc.Tooling.Core.ToolConfig])]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $allTools = Get-Config -Config tools

    $config = $allTools[$Tool]
    if (-not $config) {
        throw "Unknown tool '$Tool'. Known tools: $($allTools.Keys -join ', ')"
    }

    # Memoize by the cached entry's identity: while the config cache is warm the entry is the same object
    # (so callers get one ToolConfig instance); after a cache reset Get-Config yields a new entry object,
    # which misses here and rebuilds — tying the ToolConfig's lifetime to the config it mirrors.
    if (-not $script:toolConfigCache) {
        $script:toolConfigCache = @{}
    }
    if (-not $script:toolConfigCache.ContainsKey($config)) {
        $script:toolConfigCache[$config] = [Catzc.Tooling.Core.ToolConfig]::new($config)
    }
    $script:toolConfigCache[$config]
}
