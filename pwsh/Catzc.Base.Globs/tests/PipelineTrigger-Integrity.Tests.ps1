<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
    folder: tests
    name: pipeline-trigger-integrity-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[PipelineTrigger-Integrity.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-NAMEDGLOBSETS
---
#>

Describe 'ADO pipeline trigger globs match the globset projection' -Tag 'L2', 'integrity', 'source-only' {
    It 'every pipeline-bound globset''s pipeline trigger matches Get-GlobSetTrigger' {
        $result = Test-AdoPipelineTriggerGlob -PassThru -OutputFolder (Join-Path $TestDrive 'ado-pipeline-trigger-glob')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join '; ')
    }
}

Describe 'GitHub workflow trigger globs match the globset projection' -Tag 'L2', 'integrity', 'source-only' {
    It 'ci-pwsh.yml triggers on the pwsh globset projection' {
        $result = Test-GitHubWorkflowTriggerGlob -Name pwsh -WorkflowPath '.github/workflows/ci-pwsh.yml' -PassThru `
            -OutputFolder (Join-Path $TestDrive 'github-workflow-trigger-glob')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join '; ')
    }
}
