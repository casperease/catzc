<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
    kind: pester-test
---
#>

# Parity ([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)): every built module is the same
# module as its source folder — its exported command set equals the folder's public function files, and its private
# function set equals the folder's private/ files. Test-BuildArtifact reads the source side from the files and the
# build side from the modules as a build-mode session actually loads them. source-only: it compares the source tree
# with a fresh build of it, entered in its own child pwsh, so the answer does not depend on the mode of the session
# running it. greedy: one full build plus one importer-loading child pwsh.
Describe 'Built modules match their source folders' -Tag 'L2', 'integrity', 'greedy', 'source-only', 'ADR-DSGN-RUNMODE#2' {
    It 'every built module exports exactly its public functions and carries exactly its private ones (Test-BuildArtifact)' {
        # The default selection — the exporter's default profile — so every module it ships is compared.
        $result = Test-BuildArtifact -Facet Parity -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.Modules | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
