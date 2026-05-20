Describe 'Install-Postman' -Tag 'L0', 'logic' {
    # Like Install-Git, the actual install is a live download (dl.pstmn.io) best proven by an L2/manual run.
    # These L0 tests cover the hermetic idempotent-skip decision on every platform, with all download/CLI
    # boundaries mocked so nothing is fetched, extracted, or launched.
    BeforeEach {
        Mock Invoke-WebRequest { } -ModuleName Catzc.Tooling.Provisioning
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0 } } -ModuleName Catzc.Tooling.Provisioning
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-PathExist { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-Postman { } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'skips the download when Postman is already installed (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_install'; return
        }
        Mock Test-Path { $true } -ModuleName Catzc.Tooling.Provisioning   # Postman.exe present
        { Install-Postman } | Should -Not -Throw
        Should -Invoke Invoke-WebRequest -ModuleName Catzc.Tooling.Provisioning -Times 0
    }

    It 'skips the download when Postman is already installed (macOS/Linux)' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_install'; return
        }
        # macOS: brew reports the cask present (ExitCode 0, from BeforeEach). Linux: install dir present.
        Mock Test-Path { $true } -ModuleName Catzc.Tooling.Provisioning
        { Install-Postman } | Should -Not -Throw
        Should -Invoke Invoke-WebRequest -ModuleName Catzc.Tooling.Provisioning -Times 0
    }
}
