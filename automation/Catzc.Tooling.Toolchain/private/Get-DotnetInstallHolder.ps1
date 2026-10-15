<#
.SYNOPSIS
    Lists the processes that hold a .NET install open.
.DESCRIPTION
    Every running.NET host — the dotnet muxer, an apphost such as VBCSCompiler.exe, an MSBuild node, an editor's...
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
