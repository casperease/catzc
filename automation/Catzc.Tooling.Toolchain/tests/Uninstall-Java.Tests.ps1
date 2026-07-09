Describe 'Uninstall-Java' -Tag 'L1', 'logic' {
    BeforeAll {
        # The managed body clears JAVA_HOME (process + Windows User scope) — snapshot and restore so the test
        # leaves no persistent env change behind (ADR-AUTO-PSENV:4).
        $script:savedProcessJavaHome = $env:JAVA_HOME
        if ($IsWindows) {
            $script:savedUserJavaHome = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
        }
    }
    AfterAll {
        $env:JAVA_HOME = $script:savedProcessJavaHome
        if ($IsWindows) {
            [Environment]::SetEnvironmentVariable('JAVA_HOME', $script:savedUserJavaHome, 'User')
        }
    }
    BeforeEach {
        Mock Uninstall-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-Java { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        # Skip the Unix $PROFILE marker cleanup — no fixture profile to edit.
        Mock Test-Path { $false } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-Java
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-Java -Force with -Remove -Force' -Tag 'ADR-AUTO-REMOVE#5' {
        Uninstall-Java -Remove -Force
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE#4' {
        Uninstall-Java -Remove
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-AUTO-REMOVE#5' {
        Mock Uninstall-Tool { throw 'the manager cannot find this install' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-Java -Remove -Force
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Uninstall-Tool { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        { Uninstall-Java } | Should -Throw '*boom*'
    }
}
