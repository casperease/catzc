<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
    folder: tests/types
    name: source-check-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#4
---
#>

Describe 'SourceCheck' -Tag 'L0', 'logic' {
    It 'takes gate mode and no exemptions when nothing is given' -Tag 'ADR-AUTO-DEFAULT#6' {
        $check = [Catzc.Base.QualityGates.SourceCheck]::new('widget_check', $null)
        $check.mode | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
        $check.IsReport | Should -BeFalse
        $check.exempt.Count | Should -Be 0
        $check.IsExempt('src/widget.ps1') | Should -BeFalse
    }

    It 'maps report mode and matches its exempt globs' -Tag 'ADR-PRIN-CONFIG#4' {
        $check = [Catzc.Base.QualityGates.SourceCheck]::new('widget_check', [ordered]@{
                mode   = 'report'
                exempt = [ordered]@{ 'src/gadgets/**' = 'gadgets carry the old form on purpose' }
            })
        $check.IsReport | Should -BeTrue
        $check.exempt['src/gadgets/**'] | Should -Be 'gadgets carry the old form on purpose'
        $check.IsExempt('src/gadgets/deep/gadget.ps1') | Should -BeTrue
        $check.IsExempt('src/widget.ps1') | Should -BeFalse
    }

    It 'rejects an unknown key, an unknown mode, an exempt glob with no reason, and a malformed glob' -Tag 'ADR-PRIN-CONFIG#4' {
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
