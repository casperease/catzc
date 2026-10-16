<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1
    folder: tests
    name: install-shellcheck-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/tests/Install-Shellcheck.Tests.ps1.md
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
