Describe 'Resolve-MapLabelTerm' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:terms = @('widget', 'gadget box', 'sprocket')
    }

    It 'resolves a label that is a term, without case' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-MapLabelTerm -Label 'Gadget box' -Term $Terms | Should -Be 'gadget box'
        }
    }

    It 'resolves the plural of a term' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-MapLabelTerm -Label 'Widgets' -Term $Terms | Should -Be 'widget'
            Resolve-MapLabelTerm -Label 'Gadget boxes' -Term $Terms | Should -Be 'gadget box'
        }
    }

    It 'reads only the head before the first colon' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-MapLabelTerm -Label 'Sprocket: widgets x gadget boxes' -Term $Terms | Should -Be 'sprocket'
            Resolve-MapLabelTerm -Label 'Gizmo: widgets x gadget boxes' -Term $Terms | Should -BeNullOrEmpty
        }
    }

    It 'returns nothing for a head that only contains a term' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-MapLabelTerm -Label 'Widgets per gizmo' -Term $Terms | Should -BeNullOrEmpty
            Resolve-MapLabelTerm -Label 'Big widget' -Term $Terms | Should -BeNullOrEmpty
        }
    }

    It 'returns nothing for an empty label or an empty glossary' {
        InModuleScope Catzc.Base.Maps -Parameters @{ Terms = $script:terms } {
            Resolve-MapLabelTerm -Label '' -Term $Terms | Should -BeNullOrEmpty
            Resolve-MapLabelTerm -Label ': widget' -Term $Terms | Should -BeNullOrEmpty
            Resolve-MapLabelTerm -Label 'Widget' -Term @() | Should -BeNullOrEmpty
        }
    }
}
