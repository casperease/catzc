<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/tests/New-VSCodeTasks.Tests.ps1
    folder: tests
    name: new-vs-code-tasks-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-PWSH-PESTER#2
---
#>

Describe 'New-VSCodeTasks' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeTasksConfig]::new([ordered]@{
                    version = '2.0.0'
                    tasks   = @(
                        [ordered]@{ label = 'Fixture'; type = 'process'; command = 'widget' }
                    )
                    inputs  = @(
                        [ordered]@{ id = 'gadget'; type = 'promptString' }
                    )
                })
        }
    }

    It 'renders valid JSON carrying version, tasks and inputs, with no head of its own' {
        $text = New-VSCodeTasks
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.version | Should -Be '2.0.0'
        $json.tasks[0].label | Should -Be 'Fixture'
        $json.inputs[0].id | Should -Be 'gadget'
    }
}

Describe 'New-VSCodeTasks — real vscode-tasks.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the fast-push task and its input resolved' {
        # Get-Config constructs the VscodeTasksConfig type on load, so a render is also the shape proof.
        $text = New-VSCodeTasks
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $task = $json.tasks | Where-Object label -EQ 'Push dirty'
        $task | Should -Not -BeNullOrEmpty
        $task.args | Should -Contain '-NoProfile'
        # The input placeholder must survive the yml -> JSON round trip verbatim, and name a declared input.
        $task.options.env.COMMIT_MESSAGE | Should -Be '${input:commitMessage}'
        $json.inputs.id | Should -Contain 'commitMessage'
    }
}
