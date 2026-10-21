<#
---
catzc:
  immutable:
    with_body_sha: "598e732a6df9"
  edges:
    docs: "[Uninstall-Java.Tests.ps1.md](../../../docs/references/pwsh/catzc-tooling-toolchain/tests/Uninstall-Java.Tests.ps1.md)"
    code: pwsh/Catzc.Tooling.Toolchain/Uninstall-Java.ps1
    cites:
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
      - ADR-PWSH-ENV-NOPESTERISOLATION
---
#>

Describe 'Uninstall-Java' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:savedProcessJavaHome = $env:JAVA_HOME
    }
    AfterAll {
        $env:JAVA_HOME = $script:savedProcessJavaHome
    }
    BeforeEach {
        Mock Uninstall-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-Java { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Toolchain
        # Skip the Unix $PROFILE marker cleanup unless a test seeds a fixture profile.
        Mock Test-Path { $false } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-Java
        Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Tool -eq 'java' }
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'clears the session JAVA_HOME and announces it' {
        $env:JAVA_HOME = Join-Path $TestDrive 'widget-jdk'
        Uninstall-Java
        $env:JAVA_HOME | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Message -eq 'Session: removed JAVA_HOME' }
    }

    It 'does not announce a session JAVA_HOME it did not have' {
        $env:JAVA_HOME = $null
        Uninstall-Java
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 0 -ParameterFilter { $Message -eq 'Session: removed JAVA_HOME' }
    }

    It 'removes the persistent user JAVA_HOME through the environment seam (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }
        Uninstall-Java
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'JAVA_HOME' -and [string]::IsNullOrEmpty($Value)
        }
    }

    It 'never touches the persistent environment directly off Windows' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_profile_block'
            return
        }
        Uninstall-Java
        Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-Java -Force with -Remove -Force' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Uninstall-Java -Remove -Force
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE-DOUBLYGUARDED' {
        Uninstall-Java -Remove
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Mock Uninstall-Tool { throw 'the manager cannot find this install' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-Java -Remove -Force
        Should -Invoke Remove-Java -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Uninstall-Tool { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        { Uninstall-Java } | Should -Throw '*boom*'
    }
}
