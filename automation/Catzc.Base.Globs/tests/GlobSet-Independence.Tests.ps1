<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
    adrs:
      - ADR-FLOW-CD-GLOBS#10
---
#>

Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (ADR-FLOW-CD-GLOBS#10)' {
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'globset-independence')
        $result.IssueCount | Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (ADR-FLOW-CD-GLOBS#10) — [$($result.Issues -join '; ')]"
    }
}
