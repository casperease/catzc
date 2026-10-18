<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1
    folder: private
    name: get-config-registry
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md
    test: automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-PWSH-CACHE#4
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
