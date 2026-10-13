Describe 'Uninstall-Dotnet' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'dotnet' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { Join-Path ([IO.Path]::GetTempPath()) 'fake-dotnet' } -ModuleName Catzc.Tooling.Toolchain
        # Not installed → the managed body hits "nothing to do" and touches no env state.
        Mock Test-Path { $false } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-Dotnet { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-Dotnet
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-Dotnet -Force with -Remove -Force' -Tag 'ADR-AUTO-REMOVE#5' {
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE#4' {
        Uninstall-Dotnet -Remove
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-AUTO-REMOVE#5' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        { Uninstall-Dotnet } | Should -Throw '*boom*'
    }

    # The installed path: every boundary that touches state outside the repository is mocked — the folder delete,
    # the PATH seam (Remove-PermanentPath) and the persistent variable seam (Set-PermanentEnvironmentVariable).
    Context 'an installed SDK' {
        BeforeAll {
            $script:savedDotnetRoot = $env:DOTNET_ROOT
        }
        AfterAll {
            $env:DOTNET_ROOT = $script:savedDotnetRoot
        }
        BeforeEach {
            $script:installDir = Join-Path ([IO.Path]::GetTempPath()) 'fake-dotnet'
            $env:DOTNET_ROOT = $script:installDir
            Mock Test-Path { $true } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Path -eq $script:installDir }
            Mock Remove-Item { } -ModuleName Catzc.Tooling.Toolchain
            Mock Remove-PermanentPath { } -ModuleName Catzc.Tooling.Toolchain
            Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Toolchain
        }

        It 'deletes the install folder and drops it from the session and the persistent PATH' {
            Uninstall-Dotnet
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Path -eq $script:installDir -and $Recurse }
            $env:DOTNET_ROOT | Should -BeNullOrEmpty
            Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter {
                $Path -eq $script:installDir -and $Label -eq 'Install-Dotnet'
            }
            Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 0
        }

        It 'removes the persistent DOTNET_ROOT through the environment seam (Windows)' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
                return
            }
            Uninstall-Dotnet
            Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
                $Name -eq 'DOTNET_ROOT' -and [string]::IsNullOrEmpty($Value)
            }
        }
    }
}
