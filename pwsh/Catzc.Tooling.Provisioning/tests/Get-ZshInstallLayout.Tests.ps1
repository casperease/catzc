<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
    folder: tests
    name: get-zsh-install-layout-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-ZshInstallLayout.Tests.ps1.md](docs/references/pwsh/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-ONECATEGORY
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

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
