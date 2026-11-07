Describe 'Invoke-RootConfigGenerator' -Tag 'L0', 'logic' {
    It 'renders the importer core list through New-ImporterCore' {
        Mock New-ImporterCore -ModuleName Catzc.Base.RootConfig { "Base.Gadget`nBase.Widget`n" }
        InModuleScope Catzc.Base.RootConfig {
            Invoke-RootConfigGenerator -Name New-ImporterCore -Target 'widget/core.txt'
        } | Should -Be "Base.Gadget`nBase.Widget`n"
        Should -Invoke New-ImporterCore -ModuleName Catzc.Base.RootConfig -Times 1 -Exactly
    }

    It 'stops with a named error for a generator it does not know' {
        { InModuleScope Catzc.Base.RootConfig { Invoke-RootConfigGenerator -Name New-Sprocket -Target 'widget/core.txt' } } |
            Should -Throw "*Unknown root-config generator 'New-Sprocket'*"
    }
}
