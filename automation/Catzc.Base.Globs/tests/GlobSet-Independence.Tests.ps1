# Integrity: per-layer independence (ADR-GLOBS:10) holds in the REAL repository — within every non-loose
# layer, no two globsets (declared or derived) select a common file on their OWN contribution. The
# 'loose-fileset' layer is exempt: its sets are cross-cutting check surfaces (a track's root concern, a scan
# scope, the reserved umbrellas) and overlap by design. A module or deployable-unit that starts containing
# part of a peer — a mis-scoped include, an umbrella mis-declared as a module — fails here, locally and in
# CI. L2 because the tracked-file universe comes from the real git CLI.
Describe 'GlobSet independence' -Tag 'L2', 'integrity' {
    It 'every non-loose layer is pairwise-disjoint on OWN membership (ADR-GLOBS:10)' {
        $violations = @(Test-GlobSetIndependence)
        $report = ($violations | ForEach-Object {
                "$($_.Layer): $($_.A) <-> $($_.B) ($($_.SharedCount) shared, e.g. $($_.Shared[0]))"
            }) -join '; '
        $violations.Count | Should -Be 0 -Because "same-layer globsets must not overlap on OWN contribution (ADR-GLOBS:10) — [$report]"
    }
}
