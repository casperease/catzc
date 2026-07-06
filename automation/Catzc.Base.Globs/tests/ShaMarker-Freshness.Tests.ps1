# Integrity: the REAL repository's marker files are fresh (ADR-GLOBS:6) — every globset's committed
# .sha-markers/<name>.yml carries its definition and recomputed durable SHA, none is missing, none is orphaned. This is the
# gate that makes the commit discipline self-enforcing: a change to any unit's members without the
# regenerated marker file fails here, locally and in CI. Heal with Update-ShaMarker and commit the result.
# L2 because the tracked-file universe comes from the real git CLI.
Describe 'Marker freshness' -Tag 'L2', 'integrity' {
    It 'every globset''s marker file is fresh — no stale, missing, or orphaned marker files' {
        $notFresh = @(Test-ShaMarker | Where-Object Status -NE 'Fresh')
        $report = ($notFresh | ForEach-Object { "$($_.Name): $($_.Status)" }) -join ', '
        $notFresh.Count | Should -Be 0 -Because "every marker file must match its globset's durable SHA (run Update-ShaMarker and commit the result) — [$report]"
    }
}
