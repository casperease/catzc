Describe 'Remove-AzCli' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'widget' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-LinuxToolInstall { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'refuses a managed install and redirects to Uninstall-AzCli' -Tag 'ADR-AUTO-REMOVE#3' {
        Mock Test-ExpectedPackageManager { $true } -ModuleName Catzc.Tooling.Toolchain
        { Remove-AzCli -Force } | Should -Throw '*Uninstall-AzCli*'
        Should -Invoke Remove-LinuxToolInstall -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'on Linux, reports the plan and removes nothing without -Force' -Tag 'ADR-AUTO-REMOVE#4' {
        if (-not $IsLinux) {
            Set-ItResult -Skipped -Because 'unix_only_eviction'; return
        }
        Mock Test-ExpectedPackageManager { $false } -ModuleName Catzc.Tooling.Toolchain
        Remove-AzCli
        Should -Invoke Remove-LinuxToolInstall -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'on Linux, delegates to Remove-LinuxToolInstall under -Force, asserting no admin up front' -Tag 'ADR-AUTO-REMOVE#6', 'ADR-AUTO-REMOVE#7' {
        if (-not $IsLinux) {
            Set-ItResult -Skipped -Because 'unix_only_eviction'; return
        }
        Mock Test-ExpectedPackageManager { $false } -ModuleName Catzc.Tooling.Toolchain
        Remove-AzCli -Force
        Should -Invoke Remove-LinuxToolInstall -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}
