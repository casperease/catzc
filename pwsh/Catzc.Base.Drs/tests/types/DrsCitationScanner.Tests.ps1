Describe 'DrsCitationScanner' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    BeforeAll {
        $script:form = [Catzc.Base.Drs.DrsCodeForm]::new([ordered]@{ ADR = 3 })
        $entry = { param($rules) @{ path = 'docs/drs/widget/x.md'; rules = [string[]] $rules } }
        $script:registry = [Catzc.Base.Drs.DrsCitationMap]::new([ordered]@{
                'ADR-WIDGET-GADGET' = (& $entry @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-SPIN'))
            }, @())
        $script:scanner = [Catzc.Base.Drs.DrsCitationScanner]::new($form, $registry)
    }

    It 'lists the rules a text defines, each once, in the order they appear' {
        $text = "### Rule ADR-WIDGET-GADGET-SPIN`n`nSpins.`n`n### Rule ADR-WIDGET-GADGET-TURN`n`n### Rule ADR-WIDGET-GADGET-SPIN`n"
        $scanner.DefinedRules($text) | Should -Be @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN')
    }

    It 'cites the registered codes of the prose, never a code it does not know' {
        @($scanner.Citations('The widget turns, as ADR-WIDGET-GADGET-TURN says; ADR-WIDGET-SPROCKET-ROLL is unknown.', $false)) |
            Should -Be @('ADR-WIDGET-GADGET-TURN')
    }

    It 'leaves out the codes of a yml drawio block, which are the diagram''s' {
        $text = "Prose.`n``````yml drawio`nabout: ADR-WIDGET-GADGET-SPIN`n```````n"
        @($scanner.Citations($text, $false)) | Should -BeNullOrEmpty
    }

    It 'counts no rule the text itself defines as a citation of it' {
        $text = "### Rule ADR-WIDGET-GADGET-SPIN`n`nThe gadget spins, ADR-WIDGET-GADGET-SPIN.`n"
        @($scanner.Citations($text, $false)) | Should -BeNullOrEmpty
    }

    It 'refuses a citation scan without the citation map' {
        { [Catzc.Base.Drs.DrsCitationScanner]::new($form, $null).Citations('ADR-WIDGET-GADGET-TURN', $false) } |
            Should -Throw '*citation map*'
    }
}
