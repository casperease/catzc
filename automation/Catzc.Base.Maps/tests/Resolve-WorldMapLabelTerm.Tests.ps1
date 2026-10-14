Describe 'Resolve-WorldMapLabelTerm' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:terms = @('widget', 'gadget box', 'sprocket')
    }

    It 'resolves a label that is a term, without case' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-WorldMapLabelTerm -Label 'Gadget box' -Term $Terms | Should -Be 'gadget box'
        }
    }

    It 'resolves the plural of a term' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-WorldMapLabelTerm -Label 'Widgets' -Term $Terms | Should -Be 'widget'
            Resolve-WorldMapLabelTerm -Label 'Gadget boxes' -Term $Terms | Should -Be 'gadget box'
        }
    }

    It 'reads only the head before the first colon' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-WorldMapLabelTerm -Label 'Sprocket: widgets x gadget boxes' -Term $Terms | Should -Be 'sprocket'
            Resolve-WorldMapLabelTerm -Label 'Gizmo: widgets x gadget boxes' -Term $Terms | Should -BeNullOrEmpty
        }
    }

    It 'returns nothing for a head that only contains a term' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-WorldMapLabelTerm -Label 'Widgets per gizmo' -Term $Terms | Should -BeNullOrEmpty
            Resolve-WorldMapLabelTerm -Label 'Big widget' -Term $Terms | Should -BeNullOrEmpty
        }
    }

    It 'returns nothing for an empty label or an empty glossary' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-WorldMapLabelTerm -Label '' -Term $Terms | Should -BeNullOrEmpty
            Resolve-WorldMapLabelTerm -Label ': widget' -Term $Terms | Should -BeNullOrEmpty
            Resolve-WorldMapLabelTerm -Label 'Widget' -Term @() | Should -BeNullOrEmpty
        }
    }
}
