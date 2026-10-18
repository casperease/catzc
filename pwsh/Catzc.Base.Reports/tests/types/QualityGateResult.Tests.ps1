Describe 'Catzc.Base.Reports.QualityGateResult' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-NATIVETYPEDMODEL' {
    It 'holds the subject, the issues, the report path and the facts in the gate''s order' {
        $facts = [ordered]@{ Widgets = 3; Gadgets = 'two' }
        $result = [Catzc.Base.Reports.QualityGateResult]::new('widget', [string[]] @('first', 'second'), 'out/test-widget/1', $facts)
        $result.Subject | Should -Be 'widget'
        $result.Issues | Should -Be @('first', 'second')
        $result.IssueCount | Should -Be 2
        $result.ReportPath | Should -Be 'out/test-widget/1'
        @($result.Facts.Keys) | Should -Be @('Widgets', 'Gadgets')
        $result.Facts['Widgets'] | Should -Be 3
        $result.Facts['Gadgets'] | Should -Be 'two'
    }

    It 'declares the defaults once: no issues, no report path, no facts' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $result = [Catzc.Base.Reports.QualityGateResult]::new('gadget')
        $result.IssueCount | Should -Be 0
        $result.Issues.Count | Should -Be 0
        $result.ReportPath | Should -Be ''
        $result.Facts.Count | Should -Be 0
    }

    It 'keeps its issues and facts read-only' {
        $result = [Catzc.Base.Reports.QualityGateResult]::new('gadget', [string[]] @('one'), '', ([ordered]@{ Widgets = 1 }))
        { $result.Facts['Widgets'] = 2 } | Should -Throw
        { $result.Issues.Add('two') } | Should -Throw
    }

    It 'requires a subject' {
        { [Catzc.Base.Reports.QualityGateResult]::new('') } | Should -Throw '*the subject is required*'
    }

    It 'renders console-ready text' -Tag 'ADR-AUTO-TYPES-CONSOLEREADYTOSTRING' {
        [Catzc.Base.Reports.QualityGateResult]::new('gadget').ToString() | Should -Match 'gadget'
    }
}
