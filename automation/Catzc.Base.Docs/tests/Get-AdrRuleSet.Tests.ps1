<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
    folder: tests
    name: get-adr-rule-set-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{3,35}
      - ADR-CONF-LOADING#4
---
#>

Describe 'Get-AdrRuleSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
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

Describe 'Get-AdrRuleSet integrity' -Tag 'L1', 'integrity', 'ADR-CONF-LOADING#4' {
    It 'Test-AdrRegistry reports no issue: one ADR file per rule set, headed by its external code, none unregistered' {
        (Test-AdrRegistry -PassThru -OutputFolder (Join-Path $TestDrive 'adr-registry')).IssueCount | Should -Be 0
    }
}
