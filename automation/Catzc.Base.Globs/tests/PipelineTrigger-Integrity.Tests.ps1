<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---
#>

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
