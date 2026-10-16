<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/tests/Get-GoRelease.Tests.ps1
    folder: tests
    name: get-go-release-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/tests/Get-GoRelease.Tests.ps1.md
---
#>

Describe 'Get-GoRelease' -Tag 'L0', 'logic' {
    BeforeAll {
        # Get-GoRelease is private: reach it in the module's scope.
        function Invoke-GetGoRelease {
            param([string] $Version, [string] $Os, [string] $Arch)
            InModuleScope Catzc.Tooling.Toolchain -Parameters @{ V = $Version; O = $Os; A = $Arch } {
                param($V, $O, $A)
                Get-GoRelease -Version $V -Os $O -Arch $A
            }
        }

        function New-Release {
            param([string] $Version, [bool] $Stable = $true, [string] $Sha = 'f00d')
            [pscustomobject]@{
                version = $Version
                stable  = $Stable
                files   = @(
                    [pscustomobject]@{ filename = "$Version.src.tar.gz"; os = ''; arch = ''; kind = 'source'; version = $Version; sha256 = 'src' }
                    [pscustomobject]@{ filename = "$Version.windows-amd64.zip"; os = 'windows'; arch = 'amd64'; kind = 'archive'; version = $Version; sha256 = $Sha }
                    [pscustomobject]@{ filename = "$Version.windows-amd64.msi"; os = 'windows'; arch = 'amd64'; kind = 'installer'; version = $Version; sha256 = 'msi' }
                    [pscustomobject]@{ filename = "$Version.linux-arm64.tar.gz"; os = 'linux'; arch = 'arm64'; kind = 'archive'; version = $Version; sha256 = $Sha }
                )
            }
        }
    }
    BeforeEach {
        Mock Invoke-RestMethod {
            New-Release 'go1.28rc1' $false
            New-Release 'go1.27.10'
            New-Release 'go1.27.2'
            New-Release 'go1.27.11' $false
            New-Release 'go1.26.5'
        } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'returns the archive of the newest stable patch of the locked version' {
        $file = Invoke-GetGoRelease -Version '1.27' -Os windows -Arch amd64
        $file.filename | Should -Be 'go1.27.10.windows-amd64.zip'
        $file.sha256 | Should -Be 'f00d'
    }

    It 'picks the archive for the requested platform' {
        (Invoke-GetGoRelease -Version '1.27' -Os linux -Arch arm64).filename | Should -Be 'go1.27.10.linux-arm64.tar.gz'
    }

    It 'accepts an exact patch version' {
        (Invoke-GetGoRelease -Version '1.27.2' -Os windows -Arch amd64).filename | Should -Be 'go1.27.2.windows-amd64.zip'
    }

    It 'throws when no stable release matches' {
        { Invoke-GetGoRelease -Version '1.28' -Os windows -Arch amd64 } | Should -Throw "*No stable Go release matches the locked version '1.28'*"
    }

    It 'throws when the release has no archive for the platform' {
        { Invoke-GetGoRelease -Version '1.27' -Os darwin -Arch arm64 } | Should -Throw '*has no archive for darwin/arm64*'
    }

    It 'refuses an archive without a published SHA-256' {
        Mock Invoke-RestMethod { New-Release -Version 'go1.27.3' -Stable $true -Sha '' } -ModuleName Catzc.Tooling.Toolchain
        { Invoke-GetGoRelease -Version '1.27' -Os windows -Arch amd64 } | Should -Throw '*no published SHA-256*'
    }
}
