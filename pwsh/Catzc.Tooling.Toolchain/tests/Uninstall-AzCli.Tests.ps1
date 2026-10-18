Describe 'Uninstall-AzCli' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Uninstall-UvVenvTool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-AzCli { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-AzCli
        Should -Invoke Uninstall-UvVenvTool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-AzCli -Force after the managed uninstall with -Remove -Force' -Tag 'ADR-AUTO-REMOVE#5' {
        Uninstall-AzCli -Remove -Force
        Should -Invoke Uninstall-UvVenvTool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run — Remove-AzCli without -Force — when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE#4' {
        Uninstall-AzCli -Remove
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails — the case -Remove exists for' -Tag 'ADR-AUTO-REMOVE#5' {
        Mock Uninstall-UvVenvTool { throw 'the manager cannot find this install' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-AzCli -Remove -Force
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }
}
