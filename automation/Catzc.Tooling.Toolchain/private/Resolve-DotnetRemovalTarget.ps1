<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Resolve-DotnetRemovalTarget.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    adrs:
      - ADR-PWSH-PARAM#4
  config:
    synopsis: 'The .NET folder Remove-Dotnet evicts by default: the off-config install, never the managed one.'
    description: |-
      The folder of the `dotnet` on PATH, unless that is the managed user-space install (Test-ExpectedPackageManager
      -Path) — in a catzc session it always is, because the importer puts the managed install first — in which case the
      machine-wide C:\Program Files\dotnet, the folder a system installer places. Remove-Dotnet's -InstallDir default
      ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
    outputs: '[string] The folder.'
---
#>

function Resolve-DotnetRemovalTarget {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $machineDefault = 'C:\Program Files\dotnet'
    $command = Get-Command dotnet -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    if (-not $command) {
        return $machineDefault
    }
    $onPath = Split-Path $command.Source -Parent
    if (Test-ExpectedPackageManager -Config (Get-ToolConfig -Tool 'dotnet') -Path $onPath) {
        return $machineDefault
    }
    $onPath
}
