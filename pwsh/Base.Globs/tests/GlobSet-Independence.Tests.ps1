Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (FDR-GLOBS-NOOVERLAPWITHINLAYER)' {
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'globset-independence')
        $result.IssueCount |
            Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (FDR-GLOBS-NOOVERLAPWITHINLAYER) — [$($result.Issues -join '; ')]"
    }
}
