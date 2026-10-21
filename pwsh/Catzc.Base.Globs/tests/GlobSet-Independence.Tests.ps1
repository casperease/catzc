<#
---
catzc:
  immutable:
    with_body_sha: a2d11588fd48
  edges:
    docs: "[GlobSet-Independence.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER
---
#>

Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER)' {
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'globset-independence')
        $result.IssueCount | Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER) — [$($result.Issues -join '; ')]"
    }
}
