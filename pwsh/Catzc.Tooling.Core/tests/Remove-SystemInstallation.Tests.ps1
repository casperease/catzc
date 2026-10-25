<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Remove-SystemInstallation' -Tag 'L1', 'logic', 'ADR-AUTO-TEST-SYSTEMTESTSATLTHREE' {
    BeforeAll {
        $script:installDir = if ($IsWindows) {
            'C:\Tools\Widget'
        }
        else {
            '/opt/widget'
        }
        $script:otherDir = if ($IsWindows) {
            'C:\Tools\Gadget'
        }
        else {
            '/opt/gadget'
        }
    }

    BeforeEach {
        Mock Remove-Item { } -ModuleName Catzc.Tooling.Core
        Mock Set-EnvironmentPath { } -ModuleName Catzc.Tooling.Core
        Mock Set-PermanentEnvironmentVariable { } -ModuleName Catzc.Tooling.Core
        Mock Get-EnvironmentPath {
            "$script:otherDir;$script:installDir;$(Join-Path $script:installDir 'bin');"
        } -ModuleName Catzc.Tooling.Core
    }

    Context 'on Windows' {
        It 'deletes the install directory and removes its PATH entries through the PATH seam' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_machine_path'; return
            }
            $changed = Remove-SystemInstallation -InstallDir $script:installDir -ExtraPathDirs 'bin'

            $changed | Should -BeTrue
            Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Path -eq $script:installDir }
            Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
                $Scope -eq 'Machine' -and $Value -eq $script:otherDir
            }
        }

        It 'leaves the PATH alone and reports no change when none of its entries match' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_machine_path'; return
            }
            Mock Get-EnvironmentPath { $script:otherDir } -ModuleName Catzc.Tooling.Core

            Remove-SystemInstallation -InstallDir $script:installDir | Should -BeFalse
            Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Tooling.Core -Times 0
        }

        It 'clears each named Machine variable through the variable seam' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_machine_path'; return
            }
            Remove-SystemInstallation -InstallDir $script:installDir -EnvironmentVariables 'WIDGET_HOME', 'GADGET_ROOT' | Out-Null

            foreach ($name in 'WIDGET_HOME', 'GADGET_ROOT') {
                Should -Invoke Set-PermanentEnvironmentVariable -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
                    $Name -eq $name -and [string]::IsNullOrEmpty($Value) -and $Scope -eq 'Machine'
                }
            }
        }
    }

    It 'refuses to run off Windows' {
        if ($IsWindows) {
            Set-ItResult -Skipped -Because 'unix_only_refusal'; return
        }
        { Remove-SystemInstallation -InstallDir $script:installDir } | Should -Throw -ExpectedMessage '*only supported on Windows*'
        Should -Invoke Remove-Item -ModuleName Catzc.Tooling.Core -Times 0
    }
}
