Describe 'Install-OsvScanner' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Install-Tool -ModuleName Catzc.Tooling.Toolchain { }
        Mock Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain { }
    }

    It 'delegates to Install-Tool with the tools.yml pin' -Skip:$IsLinux {
        Install-OsvScanner
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'osv_scanner' -and $Version -eq (Get-ToolConfig -Tool 'osv_scanner').version -and -not $Force
        }
    }

    It 'passes -Force and an explicit version through' -Skip:$IsLinux {
        Install-OsvScanner -Version '2.0.1' -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'osv_scanner' -and $Version -eq '2.0.1' -and $Force
        }
    }

    It 'uninstalls through Uninstall-Tool' -Skip:$IsLinux {
        Uninstall-OsvScanner
        Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Tool -eq 'osv_scanner' }
    }

    It 'pins a user-scope winget install and probes the binary by its pinned version pattern' {
        $config = Get-ToolConfig -Tool 'osv_scanner'
        $config.winget_scope | Should -Be 'user'
        'osv-scanner version: 2.0.3' | Should -Match $config.version_pattern
    }
}
