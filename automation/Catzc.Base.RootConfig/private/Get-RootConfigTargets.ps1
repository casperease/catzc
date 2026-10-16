<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
    folder: private
    name: get-root-config-targets
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.RootConfig/tests/Get-RootConfigTargets.Tests.ps1
    adrs:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.
    description: |-
      Filters the validated registry (Get-Config -Config rootconfig) down to the entries with optIn true — the
      files the automation actually manages. Opted-out entries are inert: validated for shape when the config
      loads, but neither written nor treated as owned. The full registry semantics live in
      configs/rootconfig.yml; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    parameters:
      Config: 'The parsed rootconfig config (Get-Config -Config rootconfig): a `{ files }` object.'
    outputs: '[object[]] The opted-in RootConfigFile entries, in registry order.'
---
#>

function Get-RootConfigTargets {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    @($Config.files | Where-Object { $_.optIn })
}
