# Integrity: per-layer independence
# ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)) holds in the REAL repository —
# within every non-loose
# layer, no two globsets (declared or derived) select a common file on their OWN contribution. The
# 'loose-fileset' layer is exempt: its sets are cross-cutting check surfaces (a track's root concern, a scan
# scope, the reserved umbrellas) and overlap by design. A module or deployable-unit that starts containing
# part of a peer — a mis-scoped include, an umbrella mis-declared as a module — fails here, locally and in
# CI. L2 because the tracked-file universe comes from the real git CLI.
Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (ADR-FLOW-CD-GLOBS:10)' {
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'globset-independence')
        $result.IssueCount | Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (ADR-FLOW-CD-GLOBS:10) — [$($result.Issues -join '; ')]"
    }
}
