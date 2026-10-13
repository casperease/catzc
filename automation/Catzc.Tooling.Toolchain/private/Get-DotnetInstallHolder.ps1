<#
.SYNOPSIS
    Lists the processes that hold a .NET install open.
.DESCRIPTION
    Every running .NET host — the dotnet muxer, an apphost such as VBCSCompiler.exe, an MSBuild node, an
    editor's language server — loads the install's host resolver, host/fxr/<version>/hostfxr. The holders of
    those files are therefore the processes that would make a delete of the install fail part-way. Each holder
    is listed once. Locking is advisory off Windows, so there it lists nothing (Get-FileLockingProcess).
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
