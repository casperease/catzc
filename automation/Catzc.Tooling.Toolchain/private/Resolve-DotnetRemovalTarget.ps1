<#
.SYNOPSIS
    The .NET folder Remove-Dotnet evicts by default: the off-config install, never the managed one.
.DESCRIPTION
    The folder of the `dotnet` on PATH, unless that is the managed user-space install (Test-ExpectedPackageManager...
    [ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Resolve-DotnetRemovalTarget.ps1.md#comment1)
.OUTPUTS
    [string] The folder.
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
