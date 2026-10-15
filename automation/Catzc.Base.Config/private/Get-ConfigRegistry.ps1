<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1
    kind: function
    module: Catzc.Base.Config
    visibility: private
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-PWSH-CACHE#4
---
#>

<#
.SYNOPSIS
    Returns the config registry (this module's configs/configs.yml), keyed by config name.
.DESCRIPTION
    Loaded directly, not through Get-Config, to avoid circularity: Get-Config itself needs this registry.
#>
function Get-ConfigRegistry {
    [OutputType([System.Collections.IDictionary])]
    param()

    # Probe through session state, not the bare variable, so strict mode does not throw before the first load.
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
