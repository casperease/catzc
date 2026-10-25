<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-toolchain/private/Get-GoRelease.ps1.md"
  warning: "Generated Header"
---
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
