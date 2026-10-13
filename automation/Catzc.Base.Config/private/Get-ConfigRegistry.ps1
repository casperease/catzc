<#
.SYNOPSIS
    Returns the config override registry (this module's configs/configs.yml), keyed by config name.
.DESCRIPTION
    The optional override overlay for Get-Config: maps a config name to a non-default handler — a C# type
    (`type:`) or a custom-named pwsh validator (`pwsh:`). Most configs need no entry (they use the
    Assert-<Name>Config convention or load raw). Loaded directly here (not via Get-Config, to avoid
    circularity), validated by the C# type Catzc.Base.Config.ConfigsConfig (which the registry registers for
    its own 'configs' config), and cached for the session. The file is located through Get-CatzcModuleRoot, so
    the shipped registry resolves inside the loaded module in both run modes
    ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
#>
function Get-ConfigRegistry {
    [OutputType([System.Collections.IDictionary])]
    param()

    $cached = $ExecutionContext.SessionState.PSVariable.GetValue('script:configRegistryCache')   # strict-clean
                                                                                                 # ([ADR-AUTO-PSCACHE#4](/docs/adr/automation/powershell/script-scope-caching.md#rule-adr-auto-pscache4))
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
