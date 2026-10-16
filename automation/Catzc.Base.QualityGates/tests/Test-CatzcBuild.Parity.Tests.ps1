<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
    folder: tests
    name: test-catzc-build-parity-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md
    adrs:
      - ADR-DSGN-RUNMODE#2
---
#>

Describe 'Built modules match their source folders' -Tag 'L2', 'integrity', 'greedy', 'source-only', 'ADR-DSGN-RUNMODE#2' {
    It 'every built module exports exactly its public functions and carries exactly its private ones (Test-BuildArtifact)' {
        # The default selection — the exporter's default profile — so every module it ships is compared.
        $result = Test-BuildArtifact -Facet Parity -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
