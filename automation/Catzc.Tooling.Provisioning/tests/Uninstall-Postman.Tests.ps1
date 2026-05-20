Describe 'Uninstall-Postman' -Tag 'L0', 'logic' {
    # All filesystem/CLI boundaries are mocked: nothing is removed for real and no process launches (the L0
    # tripwire throws on a real Invoke-Executable). Platform branches self-skip off-platform.
    BeforeEach {
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Provisioning
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 1 } } -ModuleName Catzc.Tooling.Provisioning
    }

    Context 'on Windows' {
        It 'is a no-op when Postman is not installed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Mock Test-Path { $false } -ModuleName Catzc.Tooling.Provisioning
            { Uninstall-Postman } | Should -Not -Throw
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 0
        }

        It 'runs the Squirrel uninstaller and clears the install directory when installed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_uninstall'; return
            }
            Mock Test-Path { $true } -ModuleName Catzc.Tooling.Provisioning   # install dir + Update.exe present
            Uninstall-Postman
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Command -like '*--uninstall' }
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 1
        }
    }

    Context 'on non-Windows' {
        It 'is a no-op when Postman is not installed' {
            if ($IsWindows) {
                Set-ItResult -Skipped -Because 'unix_only_uninstall'; return
            }
            # macOS: brew reports the cask absent (ExitCode 1, from BeforeEach). Linux: install dir absent.
            Mock Test-Path { $false } -ModuleName Catzc.Tooling.Provisioning
            { Uninstall-Postman } | Should -Not -Throw
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }
}
