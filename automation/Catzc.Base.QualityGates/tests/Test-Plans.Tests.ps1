<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
    folder: tests
    name: test-plans-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FOLDERS#12
      - ADR-REPO-PLANS#{1-4,8}
---
#>

Describe 'Test-Plans' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:folder = Join-Path $script:root 'plans'
        $script:out = Join-Path $TestDrive 'out'
        $script:config = [Catzc.Base.QualityGates.PlansConfig]::new(@{})
        function Write-Plan {
            param([string] $Name, [string[]] $Text)
            [void][System.IO.Directory]::CreateDirectory($script:folder)
            [System.IO.File]::WriteAllText((Join-Path $script:folder $Name), ($Text -join "`n") + "`n")
        }
        function Invoke-Gate {
            Test-Plans -Path $script:folder -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        }
        $script:goodHead = @('---', 'plan:', '  status: active', '  value: medium', '  reviewed: 2026-10-17', '  targets: [widgets]', '---', '')
        $script:goodBody = @('# Widget', '', '## Open steps', '', '- [ ] Spin the widget (check: the widget spins).', '- [ ] Oil the gadget,', '      one drop (check: no squeak).')
        $script:master = @('---', 'plan:', '  status: active', '  value: highest', '  reviewed: 2026-10-17', '  role: master', '  targets: [plans]', '---', '', '# Master', '', '## Process', '', 'rules', '', '## Chunks', '', '- T001 -> task001.md (open): widgets.')
        $script:task = @('---', 'task:', '  id: "001"', '  status: open', '  plans: [plan-widget]', '  value: medium', '  blocked_on: nothing', '  targets: [plans]', '---', '', '# task001', '', '## Steps', '', '1. Spin.')
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        if (Test-Path -LiteralPath $script:root) {
            Remove-Item -LiteralPath $script:root -Recurse -Force
        }
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widgets'))
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'plans'))
        Write-Plan 'plan-widget.md' ($script:goodHead + $script:goodBody)
        Write-Plan 'plan-master.md' $script:master
        Write-Plan 'task001.md' $script:task
        Write-Plan 'prompt-widget-continue.md' @('Paste this.')
        Write-Plan 'value-of-plan.md' @('# Value', '', '| Value | Plan |', '| --- | --- |')
    }

    It 'passes a folder whose files keep every rule, and counts the files, plans and tasks' {
        $result = Invoke-Gate
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Files | Should -Be 5
        $result.Plans | Should -Be 1
        $result.Tasks | Should -Be 1
    }

    It 'names a file the folder does not accept, so a name never carries an order' -Tag 'ADR-REPO-PLANS#1' {
        Write-Plan '01-plan-widget.md' ($script:goodHead + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -BeLike 'plans/01-plan-widget.md:1 [[]ADR-REPO-PLANS#1] the name is not one the plans folder accepts*ADR-REPO-FOLDERS#12*'
    }

    It 'reports a head without the plan block, a missing key, a foreign key, a bad status, a bad rank and a missing target' -Tag 'ADR-REPO-PLANS#2' {
        Write-Plan 'plan-gadget.md' (@('---', 'gadget:', '  status: active', '---', '') + $script:goodBody)
        Write-Plan 'plan-sprocket.md' (@('---', 'plan:', '  status: pending', '  value: huge', '  colour: blue', '  targets: [nowhere]', '---', '') + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -Contain "plans/plan-gadget.md:1 [ADR-REPO-PLANS#2] the head has no 'plan:' block"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS#2] the head misses 'reviewed'"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS#2] the head key 'colour' is outside the plan keys (status, value, reviewed, targets, blocked_on, waits_on, class, next, parent, siblings, role, rule)"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS#2] status 'pending' is not one of: active, blocked"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS#2] value 'huge' is not one of the ranks: highest, high, medium-high, medium, low-medium, low"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS#2] target 'nowhere' does not exist"
    }

    It 'requires a blocked plan to name what blocks it' -Tag 'ADR-REPO-PLANS#2' {
        Write-Plan 'plan-gadget.md' (@('---', 'plan:', '  status: blocked', '  value: low', '  reviewed: 2026-10-17', '  targets: [widgets]', '---', '') + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -Be @("plans/plan-gadget.md:1 [ADR-REPO-PLANS#2] a blocked plan names what blocks it in 'blocked_on' or 'waits_on'")
    }

    It 'requires the open steps section' -Tag 'ADR-REPO-PLANS#3' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Steps', '', '- [ ] Spin (check: spins).'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @("plans/plan-gadget.md:1 [ADR-REPO-PLANS#3] the plan has no '## Open steps' section")
    }

    It 'reports an open step that names no check, at its line, and reads a wrapped step whole' -Tag 'ADR-REPO-PLANS#4' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Spin the gadget.', '- [ ] Oil it', '      (check: no squeak).', '- [x] Done already.'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @('plans/plan-gadget.md:13 [ADR-REPO-PLANS#4] the open step names no check: "- [ ] Spin the gadget."')
    }

    It 'holds a task file to its head, its number and its steps, and the master plan to its sections' -Tag 'ADR-REPO-PLANS#8' {
        Write-Plan 'task002.md' @('---', 'task:', '  id: "003"', '  status: open', '  plans: [plan-widget]', '  value: low', '  targets: [plans]', '---', '', '# task002', '', 'no steps')
        Write-Plan 'task099.md' $script:task
        Write-Plan 'plan-master.md' @('---', 'plan:', '  status: active', '  value: highest', '  reviewed: 2026-10-17', '  role: master', '  targets: [plans]', '---', '', '# Master', '', '## Chunks')
        $result = Invoke-Gate
        $result.Issues | Should -Contain "plans/task002.md:1 [ADR-REPO-PLANS#8] the task head misses 'blocked_on'"
        $result.Issues | Should -Contain "plans/task002.md:1 [ADR-REPO-PLANS#8] the task id '003' is not the file number '002'"
        $result.Issues | Should -Contain "plans/task002.md:1 [ADR-REPO-PLANS#8] the task file has no '## Steps' section"
        $result.Issues | Should -Contain 'plans/task099.md:1 [ADR-REPO-PLANS#8] task number 99 is over the roof of 50'
        $result.Issues | Should -Contain "plans/plan-master.md:1 [ADR-REPO-PLANS#8] the master plan has no '## Process' section"
    }

    It 'throws once listing every issue without -PassThru' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Spin.'))
        $thrown = { Test-Plans -Path $script:folder -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Plans failed: 1 issue(s)*'
    }
}
