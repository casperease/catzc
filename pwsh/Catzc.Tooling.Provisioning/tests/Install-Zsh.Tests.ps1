<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Install-Zsh' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:gitHome = Join-Path $TestDrive 'git'
        $script:package = 'zsh-widget-1-x86_64.pkg.tar.zst'
        $script:manifest = Join-Path $script:gitHome 'usr/share/catzc/zsh.manifest.json'
        function Set-FixtureFile {
            param([string] $Path, [string] $Text = 'widget')
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
            [System.IO.File]::WriteAllText($Path, $Text)
        }
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:gitHome)) {
            [System.IO.Directory]::Delete($script:gitHome, $true)
        }
        # Git's own tree: the MSYS2 runtime and one file the package also carries.
        Set-FixtureFile (Join-Path $script:gitHome 'usr/bin/msys-2.0.dll')
        Set-FixtureFile (Join-Path $script:gitHome 'usr/bin/msys-gadget.dll') 'git'

        Mock Get-ZshInstallLayout -ModuleName Catzc.Tooling.Provisioning {
            [pscustomobject]@{
                GitHome    = $script:gitHome
                Runtime    = Join-Path $script:gitHome 'usr/bin/msys-2.0.dll'
                Executable = Join-Path $script:gitHome 'usr/bin/zsh.exe'
                Manifest   = $script:manifest
            }
        }
        Mock Get-ToolConfig -ModuleName Catzc.Tooling.Provisioning {
            [pscustomobject]@{ msys2_url = "https://widget.example/msys/$script:package"; msys2_sha256 = 'abc123' }
        }
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning { $OutFile }
        # The extraction: the package's metadata at the root, its payload under usr/.
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Provisioning {
            $staging = Join-Path $WorkingDirectory 'package'
            Set-FixtureFile (Join-Path $staging '.PKGINFO')
            Set-FixtureFile (Join-Path $staging 'usr/bin/zsh.exe') 'zsh'
            Set-FixtureFile (Join-Path $staging 'usr/bin/msys-gadget.dll') 'package'
            Set-FixtureFile (Join-Path $staging 'usr/share/zsh/widget/gadget') 'zsh'
        }
        Mock Assert-Tool -ModuleName Catzc.Tooling.Provisioning { }
    }

    Context 'on Windows' {
        It 'installs the pinned package into the Git tree, verified by its SHA-256, and records what it added' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Install-Zsh
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "https://widget.example/msys/$script:package" -and $Sha256 -eq 'abc123' -and $OutFile -like "*$script:package"
            }
            [System.IO.File]::ReadAllText((Join-Path $script:gitHome 'usr/bin/zsh.exe')) | Should -Be 'zsh'
            [System.IO.File]::Exists((Join-Path $script:gitHome '.PKGINFO')) | Should -BeFalse
            $recorded = [System.IO.File]::ReadAllText($script:manifest) | ConvertFrom-Json
            $recorded.Package | Should -Be $script:package
            $recorded.Files | Should -Be @('usr/bin/zsh.exe', 'usr/share/zsh/widget/gadget')
            $recorded.Directories | Should -Be @('usr/share', 'usr/share/zsh', 'usr/share/zsh/widget', 'usr/share/catzc')
        }

        It 'leaves a file the Git tree already has untouched and unrecorded' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Install-Zsh
            [System.IO.File]::ReadAllText((Join-Path $script:gitHome 'usr/bin/msys-gadget.dll')) | Should -Be 'git'
            ([System.IO.File]::ReadAllText($script:manifest) | ConvertFrom-Json).Files | Should -Not -Contain 'usr/bin/msys-gadget.dll'
        }

        It 'stops and names Install-Git when the Git tree is not there, before any download' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            [System.IO.Directory]::Delete($script:gitHome, $true)
            { Install-Zsh } | Should -Throw '*Run Install-Git first*'
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
        }

        It 'stops when tools.yml pins no SHA-256, before any download' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Mock Get-ToolConfig -ModuleName Catzc.Tooling.Provisioning {
                [pscustomobject]@{ msys2_url = "https://widget.example/msys/$script:package"; msys2_sha256 = '' }
            }
            { Install-Zsh } | Should -Throw '*msys2_sha256*'
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
        }

        It 'skips the download when the pinned package is already installed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Install-Zsh
            Install-Zsh
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly
        }

        It 'stops on a zsh from another package unless -Force is passed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Install-Zsh
            Mock Get-ToolConfig -ModuleName Catzc.Tooling.Provisioning {
                [pscustomobject]@{ msys2_url = 'https://widget.example/msys/zsh-gadget-2-x86_64.pkg.tar.zst'; msys2_sha256 = 'def456' }
            }
            { Install-Zsh } | Should -Throw "*is not the pinned package 'zsh-gadget-2-x86_64.pkg.tar.zst'*Install-Zsh -Force*"
        }

        It 'with -Force removes the installed package and installs the pinned one' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Install-Zsh
            Set-FixtureFile (Join-Path $script:gitHome 'usr/share/zsh/widget/stale') 'old'
            $recorded = [System.IO.File]::ReadAllText($script:manifest) | ConvertFrom-Json
            $recorded.Files = @($recorded.Files) + 'usr/share/zsh/widget/stale'
            [System.IO.File]::WriteAllText($script:manifest, ($recorded | ConvertTo-Json -Depth 3))

            Install-Zsh -Force
            [System.IO.File]::Exists((Join-Path $script:gitHome 'usr/share/zsh/widget/stale')) | Should -BeFalse
            [System.IO.File]::Exists((Join-Path $script:gitHome 'usr/bin/zsh.exe')) | Should -BeTrue
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 2 -Exactly
        }

        It 'will not overwrite a zsh it did not install' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Set-FixtureFile (Join-Path $script:gitHome 'usr/bin/zsh.exe') 'foreign'
            { Install-Zsh -Force } | Should -Throw '*was not installed by Install-Zsh*'
            [System.IO.File]::ReadAllText((Join-Path $script:gitHome 'usr/bin/zsh.exe')) | Should -Be 'foreign'
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }

    Context 'on Linux' {
        BeforeEach {
            Mock Install-Tool -ModuleName Catzc.Tooling.Provisioning { }
        }

        It 'installs through the shared apt installer, then asserts zsh: <Description>' -ForEach @(
            @{ Description = 'a plain install'; UseForce = $false }
            @{ Description = 'a -Force install'; UseForce = $true }
        ) {
            if (-not $IsLinux) {
                Set-ItResult -Skipped -Because 'unix_only_linux_apt'; return
            }
            $script:useForce = $UseForce
            Install-Zsh -Force:$UseForce
            Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter {
                $Tool -eq 'zsh' -and [bool] $Force -eq $script:useForce
            }
            Should -Invoke Assert-Tool -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter { $Tool -eq 'zsh' }
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0
        }

        It 'stops before asserting when the shared installer stops' {
            if (-not $IsLinux) {
                Set-ItResult -Skipped -Because 'unix_only_linux_apt'; return
            }
            Mock Install-Tool -ModuleName Catzc.Tooling.Provisioning { throw 'widget needs root' }
            { Install-Zsh } | Should -Throw '*widget needs root*'
            Should -Invoke Assert-Tool -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }

    Context 'on macOS' {
        It 'asserts the system zsh and installs nothing' {
            if (-not $IsMacOS) {
                Set-ItResult -Skipped -Because 'unix_only_macos_system'; return
            }
            Install-Zsh
            Should -Invoke Assert-Tool -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter { $Tool -eq 'zsh' }
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }
}
