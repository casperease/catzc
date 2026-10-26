<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/tests/Assert-DrsCode.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Assert-DrsCode' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:checks = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                code_language = [ordered]@{ max_rule_chars = 12 }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs-checks' } { $script:checks }
    }

    It 'passes a rule code within the budget' {
        { Assert-DrsCode 'ADR-WIDGET-SPIN' -Rule } | Should -Not -Throw
    }

    It 'throws with the reason for a lower-case code' {
        { Assert-DrsCode 'ADR-widget' } | Should -Throw '*capitalization on*'
    }

    It 'throws with the count for a rule over the budget' {
        { Assert-DrsCode 'ADR-WIDGET-SPINSEVERYGADGET' -Rule } | Should -Throw '*16 characters, over the budget of 12*'
    }
}
