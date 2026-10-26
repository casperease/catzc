Describe 'ConvertTo-DrsCode' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:checks = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                code_language = [ordered]@{ max_rule_chars = 16 }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
    }

    It 'keeps a code no transform touches' {
        $result = ConvertTo-DrsCode 'ADR-WIDGET-GADGET-SPIN'
        $result.NewCode | Should -Be 'ADR-WIDGET-GADGET-SPIN'
        $result.Transforms | Should -BeNullOrEmpty
        $result.Review | Should -BeNullOrEmpty
    }

    It 'moves by the longest whole-segment prefix' {
        $move = @{ 'ADR-WIDGET' = 'EDR-WIDGET'; 'ADR-WIDGET-GADGET' = 'EDR-GIZMO' }
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-SPIN' -Move $move).NewCode | Should -Be 'EDR-GIZMO-SPIN'
        (ConvertTo-DrsCode 'ADR-WIDGETS-GADGET-SPIN' -Move $move).NewCode | Should -Be 'ADR-WIDGETS-GADGET-SPIN'
    }

    It 'drops a word the code already says at a proven word boundary, and asks for review' {
        $words = [System.Collections.Generic.HashSet[string]]::new([string[]] @('gadget', 'file'))
        $result = ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETFILE' -Words $words
        $result.NewCode | Should -Be 'ADR-WIDGET-GADGET-FILE'
        $result.Review | Should -Contain 'check that FILE still names the rule'
    }

    It 'keeps the word where no words are given, where it runs on into a longer word, or where the rest starts with no word' {
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETFILE').NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGETFILE'
        $words = [System.Collections.Generic.HashSet[string]]::new([string[]] @('gadget', 'gadgets', 'spin', 'file'))
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETSPIN' -Words $words).NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGETSPIN'
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETXQZ' -Words $words).NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGETXQZ'
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGET' -Words $words).NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGET'
    }

    It 'says a back-to-back repeated word once' {
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-SPINLEVERLEVER').NewCode | Should -Be 'ADR-WIDGET-GADGET-SPINLEVER'
    }

    It 'takes an override as written' {
        $words = [System.Collections.Generic.HashSet[string]]::new([string[]] @('gadget', 'file'))
        $result = ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETFILE' -Words $words -Override @{ 'ADR-WIDGET-GADGET-GADGETFILE' = 'EDR-WIDGET-GADGET-GADGETFILE' }
        $result.NewCode | Should -Be 'EDR-WIDGET-GADGET-GADGETFILE'
        $result.Review | Should -BeNullOrEmpty
    }

    It 'flags a rule over the budget for review, never truncating it' {
        $result = ConvertTo-DrsCode 'ADR-WIDGET-SPINSEVERYGADGETLEVER'
        $result.NewCode | Should -Be 'ADR-WIDGET-SPINSEVERYGADGETLEVER'
        $result.Review | Should -BeLike '*over the budget of 16*'
    }
}
