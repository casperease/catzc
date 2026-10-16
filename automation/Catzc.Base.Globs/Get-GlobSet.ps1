<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSet.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS#1
  config:
    synopsis: Returns globsets from the globs.yml registry — all of them, or the named ones.
    description: |-
      The typed read of the single source of truth
      ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)): configs/globs.yml, loaded and
      validated
      through Get-Config as a [Catzc.Base.Globs.GlobsConfig]. Each result is a [Catzc.Base.Globs.GlobSet]
      carrying the compiled include/exclude patterns and Matches(). An unknown name throws, naming the
      config file.
    parameters:
      Name: The globset name(s) to return. Omit for every globset, in registry order.
    examples:
      - Get-GlobSet
      - (Get-GlobSet -Name automation).Matches('automation/importer.ps1')
---
#>

function Get-GlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name
    )

    $config = Get-Config -Config globs
    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return $config.globsets
    }
    foreach ($setName in $Name) {
        $config.Get($setName)
    }
}
