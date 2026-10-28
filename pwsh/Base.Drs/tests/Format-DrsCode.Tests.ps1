Describe 'Format-DrsCode' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:checks = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{})
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
    }

    It 'compacts one rule code into each part' {
        Format-DrsCode 'ADR-WIDGET-GADGET-SPIN' | Should -Be 'ADR-WIDGET-GADGET-SPIN'
        Format-DrsCode 'ADR-WIDGET-GADGET-SPIN' -Part RecordRule | Should -Be 'GADGET-SPIN'
        Format-DrsCode 'ADR-WIDGET-GADGET-SPIN' -Part KindRule | Should -Be 'ADR-SPIN'
        Format-DrsCode 'ADR-WIDGET-GADGET-SPIN' -Part Rule | Should -Be 'SPIN'
    }

    It 'formats every code of the pipeline' {
        @('ADR-WIDGET-SPIN', 'PDR-GADGET-LIFT' | Format-DrsCode -Part Rule) | Should -Be @('SPIN', 'LIFT')
    }

    It 'throws on a code that is no rule' {
        { Format-DrsCode 'ADR-WIDGET' } | Should -Throw '*no rule*'
    }
}
