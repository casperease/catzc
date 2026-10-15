<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
    kind: test
---
#>

# Integrity: every pipeline-bound globset's ADO pipeline (and the GitHub CI workflow) declares the trigger
# path filters its projection computes — the drift quality gates over THIS repo's real pipeline files
# ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)).
# A source-path filter hand-edited out of sync with globs.yml fails here.
Describe 'ADO pipeline trigger globs match the globset projection' -Tag 'L2', 'integrity', 'source-only' {
    It 'every pipeline-bound globset''s pipeline trigger matches Get-GlobSetTrigger' {
        $result = Test-AdoPipelineTriggerGlob -PassThru -OutputFolder (Join-Path $TestDrive 'ado-pipeline-trigger-glob')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join '; ')
    }
}

Describe 'GitHub workflow trigger globs match the globset projection' -Tag 'L2', 'integrity', 'source-only' {
    It 'ci-automation.yml triggers on the automation globset projection' {
        $result = Test-GitHubWorkflowTriggerGlob -Name automation -WorkflowPath '.github/workflows/ci-automation.yml' -PassThru `
            -OutputFolder (Join-Path $TestDrive 'github-workflow-trigger-glob')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join '; ')
    }
}
