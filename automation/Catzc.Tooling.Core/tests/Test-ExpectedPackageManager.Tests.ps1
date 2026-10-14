Describe 'Test-ExpectedPackageManager — script-installed tools' -Tag 'L0', 'logic', 'ADR-AUTO-REMOVE#3' {
    BeforeEach {
        $script:managedDir = Join-Path $TestDrive 'widget-managed'
        Mock Get-ScriptInstallDir { $script:managedDir } -ModuleName Catzc.Tooling.Core
        # The record Get-ToolConfig gives a script-installed tool, so every manager kind the oracle reads is present.
        $script:config = [Catzc.Tooling.Core.ToolConfig]::new(@{
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
    # Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): an entry whose
    # mechanism is an MSYS2 package, installed on Windows into the tree Get-ScriptInstallDir names.
    BeforeEach {
        $script:tree = Join-Path $TestDrive 'gadget'
        Mock Get-ScriptInstallDir { $script:tree } -ModuleName Catzc.Tooling.Core
        $script:config = [Catzc.Tooling.Core.ToolConfig]::new(@{
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
            Set-ItResult -Skipped -Because 'an MSYS2 package installs on Windows only'
        }
        Test-ExpectedPackageManager $script:config -Path (Join-Path $TestDrive $Relative) | Should -Be $Expected
    }

    It 'on Windows, is not managed when the command is absent and no -Path is given' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'an MSYS2 package installs on Windows only'
        }
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config | Should -BeFalse
    }

    It 'off Windows, counts the system''s tool as managed when present' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'off Windows an MSYS2-package tool is the system''s'
        }
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Test-ExpectedPackageManager $script:config -Path '/elsewhere/widget' | Should -BeTrue
    }
}
