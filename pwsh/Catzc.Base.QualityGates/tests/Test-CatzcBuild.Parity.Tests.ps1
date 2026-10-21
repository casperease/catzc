<#
---
catzc:
  immutable:
    with_body_sha: "498499b05723"
  edges:
    docs: "[Test-CatzcBuild.Parity.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE-SAMEMODULEINBOTH
---
#>

Describe 'Built modules match their source folders' -Tag 'L2', 'integrity', 'greedy', 'source-only', 'ADR-DSGN-RUNMODE-SAMEMODULEINBOTH' {
    It 'every built module exports exactly its public functions and carries exactly its private ones (Test-BuildArtifact)' {
        # The default selection — the exporter's default profile — so every module it ships is compared.
        $result = Test-BuildArtifact -Facet Parity -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Facts['Modules'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
