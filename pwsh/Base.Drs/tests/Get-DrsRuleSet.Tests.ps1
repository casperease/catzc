Describe 'Get-DrsRuleSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{
                            'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' }
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }
                        }
                    }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs' } { $script:fixture }
    }

    It 'returns every typed rule set in declaration order' {
        $ruleSets = Get-DrsRuleSet
        $ruleSets | Should -HaveCount 3
        $ruleSets[0] | Should -BeOfType 'Catzc.Base.Drs.DrsRuleSet'
        @($ruleSets.External) | Should -Be @('ADR-WI-ONE', 'ADR-GA-ONE', 'ADR-GA-TWO')
    }

    It 'restricts to one folder-owning domain with -Domain' {
        @((Get-DrsRuleSet -Domain gadget).Slug) | Should -Be @('gadget-one', 'gadget-two')
    }
}

Describe 'Get-DrsRuleSet integrity' -Tag 'L1', 'integrity', 'ADR-CONF-LOADING-CSHARPCONFIGTYPE' {
    It 'Test-DrsRegistry reports no issue: one ADR file per rule set, headed by its external code, none unregistered' {
        (Test-DrsRegistry -PassThru -OutputFolder (Join-Path $TestDrive 'drs-registry')).IssueCount | Should -Be 0
    }
}
