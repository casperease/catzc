<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/tests/Install-Shellcheck.Tests.ps1.md
      source: automation/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1
---
#>

Describe 'Install-Shellcheck' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Install-Tool -ModuleName Catzc.Tooling.Toolchain { }
        Mock Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain { }
    }

    It 'delegates to Install-Tool with the tools.yml pin' -Skip:$IsLinux {
        Install-Shellcheck
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'shellcheck' -and $Version -eq (Get-ToolConfig -Tool 'shellcheck').version -and -not $Force
        }
    }

    It 'passes -Force and an explicit version through' -Skip:$IsLinux {
        Install-Shellcheck -Version '0.11.0' -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'shellcheck' -and $Version -eq '0.11.0' -and $Force
        }
    }

    It 'uninstalls through Uninstall-Tool' {
        Uninstall-Shellcheck
        Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Tool -eq 'shellcheck' }
    }
}
