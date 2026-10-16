<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
    folder: tests
    name: test-expected-package-manager-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-ExpectedPackageManager — script-installed tools' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        $script:managedDir = Join-Path $TestDrive 'widget-managed'
        Mock Get-ScriptInstallDir { $script:managedDir } -ModuleName Catzc.Tooling.Core
        # The record Get-ToolConfig gives a script-installed tool, so every manager kind the oracle reads is present.
        $script:config = [Catzc.Base.Execution.ToolConfig]::new(@{
                version = '1'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; script_install = $true
            })
    }

    It 'judges -Path, not the command on PATH: <Description>' -ForEach @(
        @{ Description = 'the managed folder'; Relative = 'widget-managed'; Expected = $true }
        @{ Description = 'a folder under it'; Relative = 'widget-managed/sdk'; Expected = $true }
        @{ Description = 'a stray folder'; Relative = 'widget-stray'; Expected = $false }
        @{ Description = 'a sibling sharing the prefix'; Relative = 'widget-managed-old'; Expected = $false }
    ) {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = (Join-Path $script:managedDir 'widget.exe') } } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive $Relative) | Should -Be $Expected
    }

    It 'without -Path, judges the command on PATH as before' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = (Join-Path $script:managedDir 'widget.exe') } } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeTrue
    }

    It 'without -Path, is not managed when the command is absent' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeFalse
    }
}

Describe 'Test-ExpectedPackageManager — MSYS2-package tools' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        $script:tree = Join-Path $TestDrive 'gadget'
        Mock Get-ScriptInstallDir { $script:tree } -ModuleName Catzc.Tooling.Core
        $script:config = [Catzc.Base.Execution.ToolConfig]::new(@{
                version = '1'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'
                msys2_url = 'https://example.com/widget-1.0-1-x86_64.pkg.tar.zst'; msys2_sha256 = 'a' * 64; windows_install_dir = 'gadget'
            })
    }

    It 'on Windows, judges -Path against the tree: <Description>' -ForEach @(
        @{ Description = 'the executable in its usr\bin'; Relative = 'gadget/usr/bin/widget.exe'; Expected = $true }
        @{ Description = 'a stray tree'; Relative = 'other/usr/bin/widget.exe'; Expected = $false }
        @{ Description = 'a sibling sharing the prefix'; Relative = 'gadget-two/usr/bin/widget.exe'; Expected = $false }
    ) {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_msys2_package'
            return
        }
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive $Relative) | Should -Be $Expected
    }

    It 'on Windows, is not managed when the command is absent and no -Path is given' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_msys2_package'
            return
        }
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeFalse
    }

    It 'off Windows, counts the system''s tool as managed when present' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_system_package'
            return
        }
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config -Path '/elsewhere/widget' | Should -BeTrue
    }

    It 'off Windows, is not managed when the system''s tool is absent' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_system_package'
            return
        }
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeFalse
    }
}

Describe 'Test-ExpectedPackageManager — MSYS2-package tools that also declare an apt package' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        $script:tree = Join-Path $TestDrive 'gadget'
        Mock Get-ScriptInstallDir { $script:tree } -ModuleName Catzc.Tooling.Core
        $script:config = [Catzc.Base.Execution.ToolConfig]::new(@{
                version = '1'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'
                msys2_url = 'https://example.com/widget-1.0-1-x86_64.pkg.tar.zst'; msys2_sha256 = 'a' * 64; windows_install_dir = 'gadget'
                apt_package = 'widget-pkg'
            })
    }

    It 'on Windows, judges the MSYS2 tree, never apt' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_msys2_package'
            return
        }
        Mock Invoke-Executable { throw 'no package manager may be asked' } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive 'gadget/usr/bin/widget.exe') | Should -BeTrue
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive 'other/usr/bin/widget.exe') | Should -BeFalse
    }

    It 'on Linux, asks dpkg for the declared package: <Description>' -ForEach @(
        @{ Description = 'dpkg owns it'; ExitCode = 0; Expected = $true }
        @{ Description = 'dpkg does not own it, even though a widget is present'; ExitCode = 1; Expected = $false }
    ) {
        if (-not $IsLinux) {
            Set-ItResult -Skipped -Because 'unix_only_linux_apt'
            return
        }
        $script:exitCode = $ExitCode
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = $script:exitCode; Output = ''; Full = '' } } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -Be $Expected
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter { $Command -eq 'dpkg -s widget-pkg' }
    }

    It 'on macOS, counts the system''s tool as managed when present' {
        if (-not $IsMacOS) {
            Set-ItResult -Skipped -Because 'unix_only_macos_system'
            return
        }
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Executable { throw 'no package manager may be asked' } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeTrue
    }
}
