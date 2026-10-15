<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists the processes that hold a .NET install open.
.DESCRIPTION
    Holders of the hostfxr file are the ones that would fail a delete part-way; off Windows locking is advisory.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Get-DotnetInstallHolder.ps1.md#comment1)
.PARAMETER InstallDir
    The .NET install directory.
.OUTPUTS
    [Catzc.Base.Files.FileLockingProcess] per holding process.
#>
function Get-DotnetInstallHolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $InstallDir
    )

    $hostResolverRoot = Join-Path $InstallDir 'host/fxr'
    if (-not [System.IO.Directory]::Exists($hostResolverRoot)) {
        return
    }

    $seen = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($hostResolver in [System.IO.Directory]::EnumerateFiles($hostResolverRoot, '*hostfxr*', [System.IO.SearchOption]::AllDirectories)) {
        foreach ($holder in Get-FileLockingProcess $hostResolver) {
            if ($seen.Add($holder.ProcessId)) {
                $holder
            }
        }
    }
}
