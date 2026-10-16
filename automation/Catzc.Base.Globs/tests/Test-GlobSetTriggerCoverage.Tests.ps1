<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md
      source: automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-GlobSetTriggerCoverage' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-GlobSet -ModuleName Catzc.Base.Globs {
            [pscustomobject]@{ Name = 'widget'; Pipeline = 'widget-ci' }
            [pscustomobject]@{ Name = 'gadget'; Pipeline = $null }
        }
        Mock Get-GlobSetTrigger -ModuleName Catzc.Base.Globs -ParameterFilter { $Name -eq 'widget' } {
            [pscustomobject]@{ Name = 'widget'; AdoInclude = @('src/widget/**', 'docs/widget.md') }
        }
        Mock Get-GlobSetFile -ModuleName Catzc.Base.Globs -ParameterFilter { $Name -eq 'widget' } {
            'src/widget/a.ps1', 'src/widget/deep/b.ps1', 'docs/widget.md'
        }
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes when every member of every pipeline-bound set matches an include' {
        $result = Test-GlobSetTriggerCoverage -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.GlobSets | Should -Be 1
        Should -Invoke Get-GlobSetFile -ModuleName Catzc.Base.Globs -Times 0 -ParameterFilter { $Name -eq 'gadget' }
    }

    It 'throws once naming every uncovered member' {
        Mock Get-GlobSetFile -ModuleName Catzc.Base.Globs -ParameterFilter { $Name -eq 'widget' } {
            'src/widget/a.ps1', 'src/gadget/c.ps1', 'docs/gadget.md'
        }
        $thrown = { Test-GlobSetTriggerCoverage -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-GlobSetTriggerCoverage failed: 2 issue(s)*'
        $message | Should -Match 'widget: member src/gadget/c.ps1 matches no ADO include pattern'
        $message | Should -Match 'widget: member docs/gadget.md matches no ADO include pattern'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        Mock Get-GlobSetFile -ModuleName Catzc.Base.Globs -ParameterFilter { $Name -eq 'widget' } { 'other/x.ps1' }
        $result = Test-GlobSetTriggerCoverage -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'glob-set-trigger-coverage'
        $result.Issues | Should -HaveCount 1
    }
}
