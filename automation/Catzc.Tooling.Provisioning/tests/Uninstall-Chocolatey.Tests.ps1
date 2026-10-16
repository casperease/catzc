<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
    folder: tests
    name: uninstall-chocolatey-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#33
---
#>

Describe 'Uninstall-Chocolatey' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Provisioning
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Provisioning
        Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Provisioning
        Mock Set-EnvironmentPath { } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
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
        Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Tooling.Provisioning -Times 0
    }

    Context 'removing an installed Chocolatey' {
        BeforeEach {
            Mock Test-Command { $true } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Command -eq 'choco' }
            Mock Assert-PathExist { } -ModuleName Catzc.Tooling.Provisioning
            Mock Get-EnvironmentPath { 'C:\Widget;C:\ProgramData\chocolatey\bin;C:\Gadget' } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Scope -eq 'Machine' }
            Mock Get-EnvironmentPath { 'C:\Users\widget\bin' } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Scope -eq 'User' }
        }

        It 'requires admin, deletes the install directory and clears ChocolateyInstall in both scopes' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_choco'; return
            }
            Uninstall-Chocolatey

            Should -Invoke Assert-IsAdministrator -ModuleName Catzc.Tooling.Provisioning -Times 1
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Provisioning -Times 1
            foreach ($scope in 'Machine', 'User') {
                Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter {
                    $Name -eq 'ChocolateyInstall' -and [string]::IsNullOrEmpty($Value) -and $Scope -eq $scope
                }
            }
        }

        It 'removes Chocolatey entries from a PATH through the seam and leaves a clean PATH untouched' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_choco'; return
            }
            Uninstall-Chocolatey

            Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter {
                $Scope -eq 'Machine' -and $Value -eq 'C:\Widget;C:\Gadget'
            }
            Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Tooling.Provisioning -Times 0 -ParameterFilter { $Scope -eq 'User' }
        }
    }
}
