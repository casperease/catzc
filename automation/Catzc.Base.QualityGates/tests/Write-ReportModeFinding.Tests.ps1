<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Write-ReportModeFinding.Tests.ps1
    folder: tests
    name: write-report-mode-finding-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Write-ReportModeFinding.Tests.ps1.md
    cites:
      - ADR-PRIN-CONFIG#4
---
#>

Describe 'Write-ReportModeFinding' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:printed = [System.Collections.Generic.List[string]]::new()
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { $script:printed.Add($Message) }
    }

    It 'prints every finding under the check''s name, then the count' -Tag 'ADR-PRIN-CONFIG#4' {
        & (Get-Module Catzc.Base.QualityGates) { Write-ReportModeFinding -Check widget_check -Finding 'a.ps1:1: one', 'b.ps1:2: two' }
        $printed | Should -HaveCount 3
        $printed[0] | Should -Be '[widget_check] a.ps1:1: one'
        $printed[1] | Should -Be '[widget_check] b.ps1:2: two'
        $printed[2] | Should -BeLike '2 widget_check finding(s) in report mode*'
    }

    It 'prints nothing for a check that found nothing' -Tag 'ADR-PRIN-CONFIG#4' {
        & (Get-Module Catzc.Base.QualityGates) { Write-ReportModeFinding -Check widget_check -Finding @() }
        $printed | Should -HaveCount 0
    }
}
