# Coverage of the native-trigger projection over THIS repo's real tree
# ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)), through its quality gate
# (Test-GlobSetTriggerCoverage — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The
# guaranteed safety property: every member of a pipeline-bound set matches at least one ADO include pattern — so an ADO
# include-only trigger is always a SUPERSET of exact membership and can never under-trigger (miss a deploy); the
# in-pipeline Test-GlobSetAffected gate supplies exactness on top. (GitHub is exact by construction: its ordered
# '!'-negation paths ARE the scan program, the same evaluator as GlobSet.Matches — covered at L0.)
Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity', 'source-only' {
    It 'ADO includes cover every member of every pipeline-bound set (include-only is a safe superset)' {
        $result = Test-GlobSetTriggerCoverage -PassThru -OutputFolder (Join-Path $TestDrive 'glob-set-trigger-coverage')
        $result.GlobSets | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
