<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Uninstall-Go.Tests.ps1
    kind: pester-test
---
#>

# Hermetic logic (L1): the managed home is a fixture folder under $TestDrive; the persistent PATH seam is mocked.
Describe 'Uninstall-Go' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:goHome = Join-Path $TestDrive 'go-home'
        $script:goConfig = [Catzc.Base.Execution.ToolConfig]::new(@{
                version = '1.27'; command = 'go'; script_install = $true; version_command = 'go version'
                version_pattern = 'go version go(?<ver>[\d.]+)'
            })
    }
    BeforeEach {
        Mock Get-ToolConfig { $script:goConfig } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { $script:goHome } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-PermanentPath { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'removes the managed home and takes its bin off PATH' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:goHome 'bin')) | Out-Null
        Uninstall-Go
        Test-Path $script:goHome | Should -BeFalse
        Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Path -eq (Join-Path $script:goHome 'bin')
        }
    }

    It 'does nothing when the managed home does not exist' {
        Uninstall-Go
        Should -Invoke Remove-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Message -like '*nothing to do' }
    }
}
