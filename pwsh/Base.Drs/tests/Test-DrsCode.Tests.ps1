Describe 'Test-DrsCode' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:checks = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                code_language = [ordered]@{ capitalization = 'on'; max_rule_chars = 12 }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
    }

    It 'accepts an upper-case code, a kind alone included' {
        Test-DrsCode 'ADR-WIDGET-GADGET' | Should -BeTrue
        Test-DrsCode 'ADR' | Should -BeTrue
    }

    It 'refuses a code with a lower-case letter while capitalization is on' {
        Test-DrsCode 'ADR-Widget-Gadget' | Should -BeFalse
        Test-DrsCode '' | Should -BeFalse
    }

    It 'holds a rule to a record segment and to the rule budget with -Rule' {
        Test-DrsCode 'ADR-WIDGET-SPIN' -Rule | Should -BeTrue
        Test-DrsCode 'ADR-WIDGET' -Rule | Should -BeFalse
        Test-DrsCode 'ADR-WIDGET-SPINSEVERYGADGET' -Rule | Should -BeFalse
    }
}
