Describe 'Uninstall-DevBoxTools' -Tag 'L0', 'logic' {
    # Pure orchestration: assert it delegates to the per-tool uninstallers. Get-ToolInstallOrder is mocked to a
    # small, realistic order — a single-word key (python) and a multi-word key (node_js) — and the real per-tool
    # uninstallers are mocked so the dynamic-dispatch loop is exercised without touching the machine. The
    # multi-word case is the regression guard: the key must be mapped through Get-ToolCommandSuffix to its
    # PascalCase command suffix (node_js -> Uninstall-NodeJs), or it silently never dispatches.
    BeforeEach {
        Mock Uninstall-Postman { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-Git { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-Python { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-NodeJs { } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolInstallOrder { @('python', 'node_js') } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'uninstalls the additional (non-locked) tools' {
        Uninstall-DevBoxTools
        Should -Invoke Uninstall-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Uninstall-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'dispatches a multi-word tool key to its PascalCase uninstaller (node_js -> Uninstall-NodeJs)' {
        Uninstall-DevBoxTools
        Should -Invoke Uninstall-NodeJs -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'dispatches a single-word tool key to its uninstaller (python -> Uninstall-Python)' {
        Uninstall-DevBoxTools
        Should -Invoke Uninstall-Python -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'throws when a locked tool has no Uninstall- function' {
        Mock Get-ToolInstallOrder { @('made_up') } -ModuleName Catzc.Tooling.Provisioning
        { Uninstall-DevBoxTools } | Should -Throw '*No Uninstall-MadeUp function found*'
    }

    It 'does not throw when there are no version-locked tools (empty install order)' {
        Mock Get-ToolInstallOrder { @() } -ModuleName Catzc.Tooling.Provisioning
        { Uninstall-DevBoxTools } | Should -Not -Throw
        Should -Invoke Uninstall-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Uninstall-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
    }
}
