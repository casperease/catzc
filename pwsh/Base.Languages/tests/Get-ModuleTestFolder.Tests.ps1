Describe 'Get-ModuleTestFolder' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeEach {
        $script:tracks = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widgets = [ordered]@{ members = @('widgets'); type = 'modules'; namespace = 'Widget' }
                    gadgets = [ordered]@{ members = @('gadgets'); type = 'modules' }
                }
            }).tracks
        Mock Get-Track -ModuleName Catzc.Base.Languages { $script:tracks }
    }

    It 'names the test folder from the module''s folder, which drops its track''s namespace, in the language''s folder case' {
        InModuleScope Catzc.Base.Languages {
            Get-ModuleTestFolder go Widget.Base.Repository
            Get-ModuleTestFolder bash Widget.Base.Repository
            Get-ModuleTestFolder python Widget.Base.Repository
        } | Should -Be @('baserepository', 'base-repository', 'base_repository')
    }

    It 'keeps a name no track''s namespace prefixes as its own folder' {
        InModuleScope Catzc.Base.Languages { Get-ModuleTestFolder bash Gadget.Spring } | Should -BeExactly 'gadget-spring'
    }
}
