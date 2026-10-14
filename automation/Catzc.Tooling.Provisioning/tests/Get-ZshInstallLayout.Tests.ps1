# Get-ZshInstallLayout over a fixture zsh entry: Get-ToolConfig is mocked, so the shipped tools.yml is never read
# ([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)), and nothing on disk is touched.
# Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-ZshInstallLayout' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:entry = [pscustomobject]@{
            command             = 'widget'
            windows_install_dir = 'WidgetGit'
            unix_install_dir    = '.widget-git'
        }
        Mock Get-ToolConfig -ModuleName Catzc.Tooling.Provisioning { $script:entry }
        $script:gitHome = Get-ScriptInstallDir -Config $script:entry
        $script:layout = InModuleScope Catzc.Tooling.Provisioning { Get-ZshInstallLayout }
    }

    It 'reads the Git tree from the zsh entry''s install directory' {
        Should -Invoke Get-ToolConfig -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -Scope Describe -ParameterFilter {
            $Tool -eq 'zsh'
        }
        $script:layout.GitHome | Should -Be $script:gitHome
    }

    It 'places the runtime, the executable and the manifest inside that tree' {
        $script:layout.Runtime | Should -Be (Join-Path $script:gitHome 'usr\bin\msys-2.0.dll')
        $script:layout.Executable | Should -Be (Join-Path $script:gitHome 'usr\bin\zsh.exe')
        $script:layout.Manifest | Should -Be (Join-Path $script:gitHome 'usr\share\catzc\zsh.manifest.json')
    }
}
