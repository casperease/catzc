<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/private/Resolve-DotnetRemovalTarget.ps1
    folder: private
    name: resolve-dotnet-removal-target
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-PWSH-PARAM#4
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
