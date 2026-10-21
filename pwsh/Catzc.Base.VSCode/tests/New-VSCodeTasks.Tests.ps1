<#
---
catzc:
  immutable:
    with_body_sha: "810b8f3bae92"
  edges:
    code: pwsh/Catzc.Base.VSCode/New-VSCodeTasks.ps1
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
      - FDR-GIT-USERRUNSGIT
---
#>

# Rests on [ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams).
Describe 'New-VsCodeTasks' -Tag 'L0', 'logic' {
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
        $text = New-VsCodeTasks
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.version | Should -Be '2.0.0'
        $json.tasks[0].label | Should -Be 'Fixture'
        $json.inputs[0].id | Should -Be 'gadget'
    }
}

Describe 'New-VsCodeTasks — real vscode-tasks.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the topic flow''s three tasks and the message input resolved' -Tag 'FDR-GIT-USERRUNSGIT' {
        # Get-Config constructs the VscodeTasksConfig type on load, so a render is also the shape proof.
        $text = New-VsCodeTasks
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.tasks.label) | Should -Be @('Sync', 'Save', 'Push')
        ($json.tasks | Where-Object label -EQ 'Sync').args | Should -Contain '. ./importer.ps1; Sync-Topic'
        foreach ($label in 'Save', 'Push') {
            $task = $json.tasks | Where-Object label -EQ $label
            $task.args | Should -Contain '-NoProfile'
            # The input placeholder must survive the yml -> JSON round trip verbatim, and name a declared input.
            $task.options.env.COMMIT_MESSAGE | Should -Be '${input:commitMessage}'
        }
        $json.inputs.id | Should -Contain 'commitMessage'
    }
}
