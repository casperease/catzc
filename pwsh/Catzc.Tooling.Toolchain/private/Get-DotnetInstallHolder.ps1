<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1
    folder: private
    name: get-dotnet-install-holder
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Get-DotnetInstallHolder.Tests.ps1
    docs: "[Get-DotnetInstallHolder.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/private/Get-DotnetInstallHolder.ps1.md)"
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
