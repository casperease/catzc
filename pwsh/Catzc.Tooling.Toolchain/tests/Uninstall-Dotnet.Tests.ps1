<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1
    folder: tests
    name: uninstall-dotnet-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Uninstall-Dotnet.Tests.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/tests/Uninstall-Dotnet.Tests.ps1.md)"
    cites:
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
---
#>

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

    It 'escalates to Remove-Dotnet -Force with -Remove -Force' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE-DOUBLYGUARDED' {
        Uninstall-Dotnet -Remove
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-Dotnet -Remove -Force
        Should -Invoke Remove-Dotnet -ModuleName Catzc.Tooling.Toolchain -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Get-ScriptInstallDir { throw 'boom' } -ModuleName Catzc.Tooling.Toolchain
        { Uninstall-Dotnet } | Should -Throw '*boom*'
    }

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
            Mock Get-DotnetInstallHolder { } -ModuleName Catzc.Tooling.Toolchain
            Mock Stop-DotnetInstallHolder { } -ModuleName Catzc.Tooling.Toolchain
            Mock Test-IsAdministrator { $false } -ModuleName Catzc.Tooling.Toolchain
            $script:widgetHolder = [Catzc.Base.Files.FileLockingProcess]::new(4242, 'widget', [datetime]'2026-01-01')
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

        It 'throws naming every holder and deletes nothing when the install is in use' {
            Mock Get-DotnetInstallHolder { $script:widgetHolder } -ModuleName Catzc.Tooling.Toolchain
            { Uninstall-Dotnet } | Should -Throw '*in use by: widget (PID 4242*rerun with -Force*'
            Should -Invoke Stop-DotnetInstallHolder -ModuleName Catzc.Tooling.Toolchain -Times 0
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Toolchain -Times 0
        }

        It 'with -Force stops exactly the named holders, then deletes' {
            Mock Get-DotnetInstallHolder { $script:widgetHolder } -ModuleName Catzc.Tooling.Toolchain
            Uninstall-Dotnet -Force
            Should -Invoke Stop-DotnetInstallHolder -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
                $InstallDir -eq $script:installDir -and @($Holder).Count -eq 1 -and $Holder[0].ProcessId -eq 4242
            }
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Toolchain -Times 1
        }

        It 'stops nothing when nothing holds the install' {
            Uninstall-Dotnet -Force
            Should -Invoke Stop-DotnetInstallHolder -ModuleName Catzc.Tooling.Toolchain -Times 0
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Toolchain -Times 1
        }

        It 'refuses an elevated shell on Windows before stopping or deleting anything, even with -Force' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_elevation_gate'
                return
            }
            Mock Test-IsAdministrator { $true } -ModuleName Catzc.Tooling.Toolchain
            Mock Get-DotnetInstallHolder { $script:widgetHolder } -ModuleName Catzc.Tooling.Toolchain
            { Uninstall-Dotnet -Force } | Should -Throw '*elevated*user-space install*winget*'
            Should -Invoke Stop-DotnetInstallHolder -ModuleName Catzc.Tooling.Toolchain -Times 0
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Toolchain -Times 0
            Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0
        }
    }
}
