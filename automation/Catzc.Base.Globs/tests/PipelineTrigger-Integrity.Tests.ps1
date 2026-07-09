# Integrity: every pipeline-bound globset's ADO pipeline (and the GitHub CI workflow) declares the trigger
# path filters its projection computes — the drift gate over THIS repo's real pipeline files (ADR-FLOW-CD-GLOBS:1).
# A source-path filter hand-edited out of sync with globs.yml fails here.
Describe 'ADO pipeline trigger globs match the globset projection' -Tag 'L2', 'integrity' {
    BeforeDiscovery {
        $script:boundSets = @(Get-GlobSet | Where-Object Pipeline | ForEach-Object Name)
    }

    It 'pipeline trigger for <_> matches Get-GlobSetTrigger' -ForEach $boundSets {
        $status = Test-AdoPipelineTriggerGlob -Name $_
        $status.Status | Should -Be 'Match' -Because "pipeline '$($status.Pipeline)' drifted: $($status.Detail)"
    }
}

Describe 'GitHub workflow trigger globs match the globset projection' -Tag 'L2', 'integrity' {
    It 'ci-automation.yml triggers on the automation globset projection' {
        $status = Test-GitHubWorkflowTriggerGlob -Name automation -WorkflowPath '.github/workflows/ci-automation.yml'
        $status.Status | Should -Be 'Match' -Because "workflow drifted: $($status.Detail)"
    }
}
