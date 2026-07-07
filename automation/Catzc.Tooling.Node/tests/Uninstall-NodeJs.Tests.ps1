Describe 'Uninstall-NodeJs' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Uninstall-Tool { } -ModuleName Catzc.Tooling.Node
        Mock Remove-NodeJs { } -ModuleName Catzc.Tooling.Node
        Mock Write-Message { } -ModuleName Catzc.Tooling.Node
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-NodeJs
        Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Node -Times 1
        Should -Invoke Remove-NodeJs -ModuleName Catzc.Tooling.Node -Times 0
    }

    It 'escalates to Remove-NodeJs -Force with -Remove -Force' -Tag 'ADR-REMOVE#5' {
        Uninstall-NodeJs -Remove -Force
        Should -Invoke Remove-NodeJs -ModuleName Catzc.Tooling.Node -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run when -Remove has no -Force' -Tag 'ADR-REMOVE#4' {
        Uninstall-NodeJs -Remove
        Should -Invoke Remove-NodeJs -ModuleName Catzc.Tooling.Node -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails' -Tag 'ADR-REMOVE#5' {
        Mock Uninstall-Tool { throw 'the manager cannot find this install' } -ModuleName Catzc.Tooling.Node
        Uninstall-NodeJs -Remove -Force
        Should -Invoke Remove-NodeJs -ModuleName Catzc.Tooling.Node -Times 1
    }

    It 'propagates a managed failure when not escalating' {
        Mock Uninstall-Tool { throw 'boom' } -ModuleName Catzc.Tooling.Node
        { Uninstall-NodeJs } | Should -Throw '*boom*'
    }
}
