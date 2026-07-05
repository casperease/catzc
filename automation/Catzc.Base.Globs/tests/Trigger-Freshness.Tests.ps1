# Integrity: the REAL repository's trigger files are fresh (ADR-GLOBS:6) — every globset's committed
# .triggers/<name>.sha256 carries its recomputed durable SHA, none is missing, none is orphaned. This is the
# gate that makes the commit discipline self-enforcing: a change to any unit's members without the
# regenerated trigger file fails here, locally and in CI. Heal with Update-Trigger and commit the result.
# L2 because the tracked-file universe comes from the real git CLI.
Describe 'Trigger freshness' -Tag 'L2', 'integrity' {
    It 'every globset''s trigger file is fresh — no stale, missing, or orphaned trigger files' {
        $notFresh = @(Test-Trigger | Where-Object Status -NE 'Fresh')
        $report = ($notFresh | ForEach-Object { "$($_.Name): $($_.Status)" }) -join ', '
        $notFresh.Count | Should -Be 0 -Because "every trigger file must match its globset's durable SHA (run Update-Trigger and commit the result) — [$report]"
    }
}
