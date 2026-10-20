<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
    folder: tests
    name: manual-test-plan-coverage-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ManualTestPlan-Coverage.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-INTEGRITYREADSFILES
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Manual test plan covers every integrity check' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-ManualTestPlan -PassThru -OutputFolder (Join-Path $TestDrive 'manual-test-plan')
    }

    It 'the AST scan found the integrity blocks (guards against a silent no-op)' {
        $result.Facts['IntegrityBlocks'] | Should -BeGreaterThan 30
    }

    It 'every integrity block has exactly one index row (matched on file + block name)' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
