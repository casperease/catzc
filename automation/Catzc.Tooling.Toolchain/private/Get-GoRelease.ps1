<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Get-GoRelease.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: private
---
#>

<#
.SYNOPSIS
    Resolves the official Go archive for a locked version from the go.dev release feed.
.DESCRIPTION
    A major.minor pin such as 1.27 matches go1.27 and every go1.27.N, and the newest stable release wins.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Get-GoRelease.ps1.md#comment1)
.PARAMETER Version
    The locked Go version (major.minor, or an exact major.minor.patch).
.PARAMETER Os
    The feed's os name: windows, linux, or darwin. Defaults to the running platform.
.PARAMETER Arch
    The feed's architecture name: amd64 or arm64. Defaults to the running process's OS architecture.
.EXAMPLE
    Get-GoRelease -Version '1.27'
#>
function Get-GoRelease {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Version,

        [ValidateSet('windows', 'linux', 'darwin')]
        [string] $Os = $(if ($IsWindows) {
                'windows'
            }
            elseif ($IsMacOS) {
                'darwin'
            }
            else {
                'linux'
            }),

        [ValidateSet('amd64', 'arm64')]
        [string] $Arch = $(if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
                'arm64'
            }
            else {
                'amd64'
            })
    )

    $feed = Invoke-RestMethod -Uri 'https://go.dev/dl/?mode=json&include=all' -UseBasicParsing
    $prefix = "go$Version"
    $release = @($feed) |
        Where-Object { $_.stable -and ($_.version -eq $prefix -or $_.version -like "$prefix.*") } |
        Sort-Object { [version]($_.version -replace '^go', '') } -Descending |
        Select-Object -First 1
    Assert-NotNull $release -ErrorText "No stable Go release matches the locked version '$Version' in the go.dev release feed."

    $file = @($release.files) |
        Where-Object { $_.os -eq $Os -and $_.arch -eq $Arch -and $_.kind -eq 'archive' } |
        Select-Object -First 1
    Assert-NotNull $file -ErrorText "Go $($release.version) has no archive for $Os/$Arch in the go.dev release feed."
    Assert-NotNullOrWhitespace $file.sha256 -ErrorText "Go archive '$($file.filename)' has no published SHA-256 in the go.dev release feed — refusing an unverified download."

    $file
}
