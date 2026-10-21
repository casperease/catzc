<#
---
catzc:
  immutable:
    with_body_sha: "46fba5526535"
  edges:
    docs: "[SourceCheck.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/types/SourceCheck.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY
---
#>

Describe 'SourceCheck' -Tag 'L0', 'logic' {
    It 'takes gate mode and no exemptions when nothing is given' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $check = [Catzc.Base.QualityGates.SourceCheck]::new('widget_check', $null)
        $check.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
        $check.IsReport | Should -BeFalse
        $check.exempt.Count | Should -Be 0
        $check.IsExempt('src/widget.ps1') | Should -BeFalse
    }

    It 'maps report mode and matches its exempt globs' -Tag 'ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY' {
        $check = [Catzc.Base.QualityGates.SourceCheck]::new('widget_check', [ordered]@{
                mode   = 'report'
                exempt = [ordered]@{ 'src/gadgets/**' = 'gadgets carry the old form on purpose' }
            })
        $check.IsReport | Should -BeTrue
        $check.exempt['src/gadgets/**'] | Should -Be 'gadgets carry the old form on purpose'
        $check.IsExempt('src/gadgets/deep/gadget.ps1') | Should -BeTrue
        $check.IsExempt('src/widget.ps1') | Should -BeFalse
    }

    It 'rejects an unknown key, an unknown mode, an exempt glob with no reason, and a malformed glob' -Tag 'ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY' {
        $thrown = { [Catzc.Base.QualityGates.SourceCheck]::new('widget_check', [ordered]@{
                    gadget = 1
                    mode   = 'loud'
                    exempt = [ordered]@{ 'src/**' = ' '; '/rooted' = 'a reason' }
                }) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike "*widget_check*unknown key 'gadget'*"
        $message | Should -BeLike "*mode 'loud' is not one of: gate, report*"
        $message | Should -BeLike "*exempt 'src/**' needs the reason*"
        $message | Should -BeLike "*no leading '/'*"
    }
}
