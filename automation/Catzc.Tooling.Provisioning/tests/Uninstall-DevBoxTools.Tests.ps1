Describe 'Uninstall-DevBoxTools' -Tag 'L0', 'logic' {
    # Pure orchestration: assert it delegates to the per-tool uninstallers. Get-ToolInstallOrder is mocked to
    # a non-production order whose tools have no Uninstall-<tool> function, so the dynamic dispatch loop runs
    # and safely skips each via its Get-Command guard. Proving the reverse-order dispatch actually invokes a
    # real Uninstall-<tool> belongs in an integration run, where those functions exist.
    BeforeEach {
        Mock Uninstall-Postman { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-Git { } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolInstallOrder { @('alpha-tool', 'beta-tool') } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'uninstalls the additional (non-locked) tools' {
        Uninstall-DevBoxTools
        Should -Invoke Uninstall-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Uninstall-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'skips a locked tool that has no Uninstall- function instead of throwing' {
        { Uninstall-DevBoxTools } | Should -Not -Throw
    }

    It 'does not throw when there are no version-locked tools (empty install order)' {
        Mock Get-ToolInstallOrder { @() } -ModuleName Catzc.Tooling.Provisioning
        { Uninstall-DevBoxTools } | Should -Not -Throw
        Should -Invoke Uninstall-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Uninstall-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
    }
}
