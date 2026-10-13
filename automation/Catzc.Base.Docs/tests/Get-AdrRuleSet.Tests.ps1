# Get-AdrRuleSet over a fixture AdrsConfig (Get-Config mocked): the flattening and effective codes are AdrsConfig
# construction rules (its type test), so this pins only the projection and the -Domain filter. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-AdrRuleSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'implementation'; description = 'The gadget implementation.'; depends_on = @('widget')
                        rulesets = [ordered]@{
                            'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' }
                            'gadget-two' = [ordered]@{ external = 'ADR-GA-TWO' }
                        }
                    }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
    }

    It 'returns every typed rule set in declaration order' {
        $ruleSets = Get-AdrRuleSet
        $ruleSets | Should -HaveCount 3
        $ruleSets[0] | Should -BeOfType 'Catzc.Base.Docs.AdrRuleSet'
        @($ruleSets.External) | Should -Be @('ADR-WI-ONE', 'ADR-GA-ONE', 'ADR-GA-TWO')
    }

    It 'restricts to one folder-owning domain with -Domain' {
        @((Get-AdrRuleSet -Domain gadget).Slug) | Should -Be @('gadget-one', 'gadget-two')
    }
}

# Integrity: adrs.yml and the ADR rule files agree, through the quality gate Test-AdrRegistry
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
Describe 'Get-AdrRuleSet integrity' -Tag 'L1', 'integrity', 'ADR-CONF-LOADING#4' {
    It 'Test-AdrRegistry reports no issue: one ADR file per rule set, headed by its external code, none unregistered' {
        (Test-AdrRegistry -PassThru -OutputFolder (Join-Path $TestDrive 'adr-registry')).IssueCount | Should -Be 0
    }
}
