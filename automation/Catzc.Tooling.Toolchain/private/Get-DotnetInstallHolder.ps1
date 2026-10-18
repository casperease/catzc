<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1
    folder: private
    name: get-dotnet-install-holder
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
    test: automation/Catzc.Tooling.Toolchain/tests/Get-DotnetInstallHolder.Tests.ps1
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
