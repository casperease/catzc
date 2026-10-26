<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/tests/ConvertTo-DrsCode.Tests.ps1.md"
  header: "generated"
---
#>

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

    It 'drops a word the code already says, and asks for review' {
        $result = ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETFILE'
        $result.NewCode | Should -Be 'ADR-WIDGET-GADGET-FILE'
        $result.Review | Should -Contain 'check that FILE still names the rule'
    }

    It 'keeps a remainder that reads as a suffix' {
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETING').NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGETING'
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGET').NewCode | Should -Be 'ADR-WIDGET-GADGET-GADGET'
    }

    It 'says a back-to-back repeated word once' {
        (ConvertTo-DrsCode 'ADR-WIDGET-GADGET-SPINLEVERLEVER').NewCode | Should -Be 'ADR-WIDGET-GADGET-SPINLEVER'
    }

    It 'takes an override as written' {
        $result = ConvertTo-DrsCode 'ADR-WIDGET-GADGET-GADGETFILE' -Override @{ 'ADR-WIDGET-GADGET-GADGETFILE' = 'EDR-WIDGET-GADGET-GADGETFILE' }
        $result.NewCode | Should -Be 'EDR-WIDGET-GADGET-GADGETFILE'
        $result.Review | Should -BeNullOrEmpty
    }

    It 'flags a rule over the budget for review, never truncating it' {
        $result = ConvertTo-DrsCode 'ADR-WIDGET-SPINSEVERYGADGETLEVER'
        $result.NewCode | Should -Be 'ADR-WIDGET-SPINSEVERYGADGETLEVER'
        $result.Review | Should -BeLike '*over the budget of 16*'
    }
}
