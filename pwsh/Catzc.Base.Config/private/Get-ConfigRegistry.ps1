<#
---
catzc:
  immutable:
    with_body_sha: ebe30c79cbf2
  edges:
    test: pwsh/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1
    docs: "[Get-ConfigRegistry.ps1.md](docs/references/pwsh/catzc-base-config/private/Get-ConfigRegistry.ps1.md)"
    cites:
      - ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
---
#>

function Get-ConfigRegistry {
    [OutputType([System.Collections.IDictionary])]
    param()

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
