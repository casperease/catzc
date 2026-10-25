<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/private/Get-ConfigRegistry.ps1.md"
  header: "generated"
---
#>

function Get-ConfigRegistry {
    [OutputType([System.Collections.IDictionary])]
    param()

    # Probed through the variable table, so a first call under strict mode finds no cache instead of throwing.
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
