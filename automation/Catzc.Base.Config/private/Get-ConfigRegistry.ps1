<#
.SYNOPSIS
    Returns the config registry (this module's configs/configs.yml), keyed by config name.
.DESCRIPTION
    The registry Get-Config reads: maps each shipped config name to its C# config type (`type:`).
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    [comment:1](/docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md#comment1)
#>
function Get-ConfigRegistry {
    [OutputType([System.Collections.IDictionary])]
    param()

    # strict-clean
    # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
    # [comment:2](/docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md#comment2)
    $cached = $ExecutionContext.SessionState.PSVariable.GetValue('script:configRegistryCache')
    if ($null -ne $cached) {
        return $cached
    }

    $path = Get-CatzcModuleRoot 'configs/configs.yml'
    if (-not (Test-Path $path)) {
        $script:configRegistryCache = [ordered]@{}
        return $script:configRegistryCache
    }

    $registry = Get-Content $path -Raw | ConvertFrom-Yaml -Ordered
    [void][Catzc.Base.Config.ConfigsConfig]::new($registry)   # ctor validates; throws on a malformed registry

    $script:configRegistryCache = if ($registry -and $registry.Contains('configs') -and $registry['configs']) {
        $registry['configs']
    }
    else {
        [ordered]@{}
    }
    $script:configRegistryCache
}
