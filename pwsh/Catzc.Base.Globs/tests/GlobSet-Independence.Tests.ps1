<#
---
catzc:
  immutable:
    with_body_sha: "49211612be85"
  edges:
    docs: "[GlobSet-Independence.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md)"
    cites:
      - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
---
#>

Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER)' {
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'globset-independence')
        $result.IssueCount | Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER) — [$($result.Issues -join '; ')]"
    }
}
