Describe 'Uninstall-Chocolatey' -Tag 'L0', 'logic' {
    # Only the idempotent no-op branches are exercised here: the removal path calls
    # [Environment]::SetEnvironmentVariable(..., 'Machine') (a static .NET call that needs admin and cannot
    # be mocked), so it is left to a real-machine L2/manual run. These tests assert the function does NOTHING
    # — and in particular never escalates or deletes — when there is nothing to uninstall.
    BeforeEach {
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Provisioning
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'is a no-op on non-Windows platforms' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_noop'; return
        }
        { Uninstall-Chocolatey } | Should -Not -Throw
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Provisioning -Times 0
        Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 0
    }

    It 'is a no-op when Chocolatey is not installed' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_choco'; return
        }
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Command -eq 'choco' }
        { Uninstall-Chocolatey } | Should -Not -Throw
        # Never escalates to admin or deletes anything when there is nothing to remove.
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Provisioning -Times 0
        Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 0
    }
}
