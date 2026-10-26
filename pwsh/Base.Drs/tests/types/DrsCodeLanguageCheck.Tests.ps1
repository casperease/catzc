<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-drs/tests/types/DrsCodeLanguageCheck.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'DrsCodeLanguageCheck' -Tag 'L0', 'logic' {
    It 'declares capitalization on and a rule budget of 24 by default' {
        $check = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{}).code_language
        $check.capitalization | Should -Be ([Catzc.Base.Drs.DrsCapitalization]::On)
        $check.max_rule_chars | Should -Be 24
    }

    It 'reads capitalization and the budget from the config' {
        $check = [Catzc.Base.Drs.DrsChecksConfig]::new([ordered]@{
                code_language = [ordered]@{ mode = 'report'; capitalization = 'On'; max_rule_chars = 10 }
            }).code_language
        $check.mode | Should -Be ([Catzc.Base.Reports.CheckMode]::Report)
        $check.max_rule_chars | Should -Be 10
    }

    It 'refuses an unknown capitalization and a budget below one' {
        $config = [ordered]@{ code_language = [ordered]@{ capitalization = 'pascal'; max_rule_chars = 0 } }
        $err = { [Catzc.Base.Drs.DrsChecksConfig]::new($config) } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*capitalization 'pascal' is not a mode (allowed: on)*"
        $err.Exception.Message | Should -BeLike "*max_rule_chars '0' must be a whole number of 1 or more*"
    }

    It 'names why a text is no code or no rule within the budget' {
        $check = [Catzc.Base.Drs.DrsCodeLanguageCheck]::new([Catzc.Base.Drs.DrsCapitalization]::On, 8)
        $check.Violation('ADR-WIDGET-SPIN', $true) | Should -BeNullOrEmpty
        $check.Violation('ADR-widget', $false) | Should -BeLike '*capitalization on*'
        $check.Violation('ADR-WIDGET', $true) | Should -BeLike '*no rule*'
        $check.Violation('ADR-WIDGET-SPINSGADGET', $true) | Should -BeLike '*11 characters, over the budget of 8*'
    }
}
