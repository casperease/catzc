<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{3,35}
---
#>

Describe 'Test-GitHubWorkflowTriggerGlob' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot { 'X:/repo' } -ModuleName Catzc.Base.Globs
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{ 'widget' = @{ description = 'w'; layer = 'deployable-unit'; include = @('src/**'); exclude = @('src/gen/**') } }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Test-Path { $true } -ModuleName Catzc.Base.Globs
        # The real ordered projection of the fixture set — what a clean workflow declares.
        $script:projection = [string[]] @((Get-GlobSetTrigger -GlobSet (Get-GlobSet -Name widget)).GitHub)
    }

    It 'passes when both filters equal the ordered projection' -Tag 'ADR-AUTO-TEST#35' {
        Mock Get-PipelineTrigger { [pscustomobject]@{ PushPaths = $script:projection; PrPaths = $script:projection } } -ModuleName Catzc.Base.Globs

        { Test-GitHubWorkflowTriggerGlob -Name widget -WorkflowPath '.github/workflows/ci-widget.yml' -OutputFolder (Join-Path $TestDrive 'gh') } |
            Should -Not -Throw
    }

    It 'throws once naming every drifted filter' -Tag 'ADR-AUTO-TEST#35' {
        $reversed = [string[]] @($script:projection)
        [System.Array]::Reverse($reversed)
        Mock Get-PipelineTrigger { [pscustomobject]@{ PushPaths = $reversed; PrPaths = @('other/**') } } -ModuleName Catzc.Base.Globs

        $thrown = { Test-GitHubWorkflowTriggerGlob -Name widget -WorkflowPath '.github/workflows/ci-widget.yml' -OutputFolder (Join-Path $TestDrive 'gh') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-GitHubWorkflowTriggerGlob failed: 1 issue(s)*'
        $thrown.Exception.Message | Should -Match 'widget: \.github/workflows/ci-widget\.yml trigger drifted .* on on\.push\.paths, on\.pull_request\.paths'
    }

    It 'reports a missing workflow file under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        Mock Test-Path { $false } -ModuleName Catzc.Base.Globs

        $result = Test-GitHubWorkflowTriggerGlob -Name widget -WorkflowPath '.github/workflows/ci-widget.yml' -PassThru -OutputFolder (Join-Path $TestDrive 'gh')
        $result.Subject | Should -Be 'github-workflow-trigger-glob'
        $result.GlobSet | Should -Be 'widget'
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -Be 'widget: workflow file not found: .github/workflows/ci-widget.yml'
    }
}
