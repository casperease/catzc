<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
      source: automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#9
---
#>

Describe 'Uninstall-Zsh' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:gitHome = Join-Path $TestDrive 'git'
        $script:manifest = Join-Path $script:gitHome 'usr/share/catzc/zsh.manifest.json'
        function Set-FixtureFile {
            param([string] $Relative, [string] $Text = 'widget')
            $path = Join-Path $script:gitHome $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
        }
        function Test-FixturePath {
            param([string] $Relative)
            $path = Join-Path $script:gitHome $Relative
            [System.IO.File]::Exists($path) -or [System.IO.Directory]::Exists($path)
        }
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:gitHome)) {
            [System.IO.Directory]::Delete($script:gitHome, $true)
        }
        # Git's own files, and the files and folders a zsh install added, as its manifest records them.
        Set-FixtureFile 'usr/bin/msys-2.0.dll'
        Set-FixtureFile 'usr/bin/msys-gadget.dll'
        Set-FixtureFile 'usr/bin/zsh.exe'
        Set-FixtureFile 'usr/share/zsh/widget/gadget'
        $recorded = [ordered]@{
            Package     = 'zsh-widget-1-x86_64.pkg.tar.zst'
            Files       = @('usr/bin/zsh.exe', 'usr/share/zsh/widget/gadget', 'usr/share/zsh/widget/gone')
            Directories = @('usr/share/zsh', 'usr/share/zsh/widget', 'usr/share/catzc')
        }
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:manifest))
        [System.IO.File]::WriteAllText($script:manifest, ($recorded | ConvertTo-Json -Depth 3))

        Mock Get-ZshInstallLayout -ModuleName Catzc.Tooling.Provisioning {
            [pscustomobject]@{
                GitHome    = $script:gitHome
                Runtime    = Join-Path $script:gitHome 'usr/bin/msys-2.0.dll'
                Executable = Join-Path $script:gitHome 'usr/bin/zsh.exe'
                Manifest   = $script:manifest
            }
        }
    }

    Context 'on Windows' {
        It 'removes exactly the files and folders the manifest lists, then the manifest' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Uninstall-Zsh
            Test-FixturePath 'usr/bin/zsh.exe' | Should -BeFalse
            Test-FixturePath 'usr/share/zsh' | Should -BeFalse
            Test-FixturePath 'usr/share/catzc' | Should -BeFalse
            Test-FixturePath 'usr/bin/msys-2.0.dll' | Should -BeTrue
            Test-FixturePath 'usr/bin/msys-gadget.dll' | Should -BeTrue
        }

        It 'keeps a listed folder that holds a file it did not install' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Set-FixtureFile 'usr/share/zsh/widget/kept'
            Uninstall-Zsh
            Test-FixturePath 'usr/share/zsh/widget/kept' | Should -BeTrue
            Test-FixturePath 'usr/share/zsh/widget/gadget' | Should -BeFalse
        }

        It 'is a no-op without a manifest' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            [System.IO.File]::Delete($script:manifest)
            { Uninstall-Zsh } | Should -Not -Throw
            Test-FixturePath 'usr/bin/zsh.exe' | Should -BeTrue
        }

        It 'is idempotent: a second run finds nothing to do' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Uninstall-Zsh
            { Uninstall-Zsh } | Should -Not -Throw
        }
    }

    Context 'on Linux' {
        BeforeEach {
            Mock Uninstall-Tool -ModuleName Catzc.Tooling.Provisioning { }
        }

        It 'removes zsh through the shared apt uninstaller, the manager Install-Zsh used, and leaves the Git tree alone' {
            if (-not $IsLinux) {
                Set-ItResult -Skipped -Because 'unix_only_linux_apt'; return
            }
            Uninstall-Zsh
            Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter { $Tool -eq 'zsh' }
            Should -Invoke Get-ZshInstallLayout -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }

    Context 'on Windows and macOS' {
        It 'never reaches the shared apt uninstaller' {
            if ($IsLinux) {
                Set-ItResult -Skipped -Because 'windows_or_macos_only_no_apt'; return
            }
            Mock Uninstall-Tool -ModuleName Catzc.Tooling.Provisioning { throw 'apt is Linux only' }
            { Uninstall-Zsh } | Should -Not -Throw
            Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }

    Context 'on macOS' {
        It 'has nothing to uninstall: zsh is the system''s' {
            if (-not $IsMacOS) {
                Set-ItResult -Skipped -Because 'unix_only_macos_system'; return
            }
            { Uninstall-Zsh } | Should -Not -Throw
            Should -Invoke Get-ZshInstallLayout -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }
}
