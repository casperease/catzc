<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1
    kind: private-function
    module: Catzc.Tooling.Toolchain
    visibility: private
  config:
    synopsis: Lists the processes that hold a .NET install open.
    description: |-
      Every running .NET host — the dotnet muxer, an apphost such as VBCSCompiler.exe, an MSBuild node, an
      editor's language server — loads the install's host resolver, host/fxr/<version>/hostfxr. The holders of
      those files are therefore the processes that would make a delete of the install fail part-way. Each holder
      is listed once. Locking is advisory off Windows, so there it lists nothing (Get-FileLockingProcess).
    parameters:
      InstallDir: The .NET install directory.
    outputs: '[Catzc.Base.Files.FileLockingProcess] per holding process.'
---
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
    # hostfxr sits under one version folder of host/fxr; the third level is headroom.
    foreach ($hostResolver in Get-ChildPath $hostResolverRoot -File -Filter '*hostfxr*' -Depth 3) {
        foreach ($holder in Get-FileLockingProcess $hostResolver) {
            if ($seen.Add($holder.ProcessId)) {
                $holder
            }
        }
    }
}
