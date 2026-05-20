Describe 'Uninstall-Git' -Tag 'L0', 'logic' {
    # Every filesystem/PATH/CLI boundary is mocked so nothing is removed for real and no process launches
    # (the L0 tripwire would throw on a real Invoke-Executable). Platform branches self-skip off-platform.
    BeforeEach {
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Provisioning
        Mock Remove-PermanentPath { } -ModuleName Catzc.Tooling.Provisioning
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Provisioning
    }

    Context 'on Windows' {
        It 'is a no-op when Git is not installed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Mock Test-Path { $false } -ModuleName Catzc.Tooling.Provisioning
            { Uninstall-Git } | Should -Not -Throw
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 0
            Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Provisioning -Times 0
        }

        It 'removes the install directory and cleans PATH when Git is installed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Mock Test-Path { $true } -ModuleName Catzc.Tooling.Provisioning
            Uninstall-Git
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Path -like '*Git' }
            Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Path -like '*Git*cmd' }
        }
    }

    Context 'on non-Windows' {
        It 'delegates removal to the platform package manager' {
            if ($IsWindows) {
                Set-ItResult -Skipped -Because 'unix_only_uninstall'; return
            }
            Mock Test-Command { $true } -ModuleName Catzc.Tooling.Provisioning   # macOS: git present, proceed
            { Uninstall-Git } | Should -Not -Throw
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 1
        }
    }
}
