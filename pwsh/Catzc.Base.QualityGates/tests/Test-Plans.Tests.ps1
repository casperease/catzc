<#
---
catzc:
  immutable:
    with_body_sha: f40f1c1dd8ee
  edges:
    code: pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-FOLDERS-STABLEFILENAMES
      - ADR-REPO-PLANS-ONETOPICONEFILE
      - ADR-REPO-PLANS-PLANHEAD
      - ADR-REPO-PLANS-THREEPARTS
      - ADR-REPO-PLANS-ONESHAPE
      - ADR-REPO-PLANS-OPENSTEP
      - ADR-REPO-PLANS-MASTERANDTASKS
---
#>

Describe 'Test-Plans' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE' {
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
        $script:master = @('---', 'plan:', '  status: active', '  value: highest', '  reviewed: 2026-10-17', '  role: master', '  targets: [plans]', '---', '', '# Master', '', '## Process', '', 'rules', '', '## Chunks', '', '- spin the widget -> task-spin-widget.md (open): widgets.', '- widget -> plan-widget.md: spin it.', '- gadget -> plan-gadget.md: oil it.', '- sprocket -> plan-sprocket.md: turn it.')
        $script:value = @('# Value', '', '| Value | Plan |', '| --- | --- |', '| medium | plan-widget |', '| low | plan-gadget |', '| low | plan-sprocket |')
        $script:task = @('---', 'task:', '  status: open', '  plans: [plan-widget]', '  value: medium', '  blocked_on: nothing', '  targets: [plans]', '---', '', '# Spin the widget', '', '## Steps', '', '1. Spin.')
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
        Write-Plan 'task-spin-widget.md' $script:task
        Write-Plan 'prompt-widget-continue.md' @('Paste this.')
        Write-Plan 'value-of-plan.md' $script:value
    }

    It 'passes a folder whose files keep every rule, and counts the files, plans and tasks' {
        $result = Invoke-Gate
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Files'] | Should -Be 5
        $result.Facts['Plans'] | Should -Be 1
        $result.Facts['Tasks'] | Should -Be 1
    }

    It 'names a file the folder does not accept, so a name never carries an order' -Tag 'ADR-REPO-PLANS-ONETOPICONEFILE' {
        Write-Plan '01-plan-widget.md' ($script:goodHead + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -BeLike 'plans/01-plan-widget.md:1 [[]ADR-REPO-PLANS-ONETOPICONEFILE] the name is not one the plans folder accepts*ADR-REPO-FOLDERS-STABLEFILENAMES*'
    }

    It 'reports a head without the plan block, a missing key, a foreign key, a bad status, a bad rank and a missing target' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        Write-Plan 'plan-gadget.md' (@('---', 'gadget:', '  status: active', '---', '') + $script:goodBody)
        Write-Plan 'plan-sprocket.md' (@('---', 'plan:', '  status: pending', '  value: huge', '  colour: blue', '  targets: [nowhere]', '---', '') + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -Contain "plans/plan-gadget.md:1 [ADR-REPO-PLANS-PLANHEAD] the head has no 'plan:' block"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS-PLANHEAD] the head misses 'reviewed'"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS-PLANHEAD] the head key 'colour' is outside the plan keys (status, value, reviewed, targets, blocked_on, waits_on, class, next, parent, siblings, role, rule)"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS-PLANHEAD] status 'pending' is not one of: active, blocked"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS-PLANHEAD] value 'huge' is not one of the ranks: highest, high, medium-high, medium, low-medium, low"
        $result.Issues | Should -Contain "plans/plan-sprocket.md:1 [ADR-REPO-PLANS-PLANHEAD] target 'nowhere' does not exist"
    }

    It 'requires a blocked plan to name what blocks it' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        Write-Plan 'plan-gadget.md' (@('---', 'plan:', '  status: blocked', '  value: low', '  reviewed: 2026-10-17', '  targets: [widgets]', '---', '') + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -Be @("plans/plan-gadget.md:1 [ADR-REPO-PLANS-PLANHEAD] a blocked plan names what blocks it in 'blocked_on' or 'waits_on'")
    }

    It 'requires the open steps section' -Tag 'ADR-REPO-PLANS-ONESHAPE' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Steps', '', '- [ ] Spin (check: spins).'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @("plans/plan-gadget.md:1 [ADR-REPO-PLANS-ONESHAPE] the plan has no '## Open steps' section")
    }

    It 'reports an open step that names no check, at its line, and reads a wrapped step whole' -Tag 'ADR-REPO-PLANS-OPENSTEP' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Spin the gadget.', '- [ ] Oil it', '      (check: no squeak).', '- [x] Done already.'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @('plans/plan-gadget.md:13 [ADR-REPO-PLANS-OPENSTEP] the open step names no check: "- [ ] Spin the gadget."')
    }

    It 'reads a numbered open step like a bulleted one, and reports a numbered step without a checkbox' -Tag 'ADR-REPO-PLANS-OPENSTEP' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '1. [ ] Spin the gadget.', '2. Oil it (check: no squeak).', '3. [ ] Turn it,', '       slowly (check: it turns).', '', '## Refs', '', '1. A numbered ref.'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @(
            'plans/plan-gadget.md:14 [ADR-REPO-PLANS-OPENSTEP] the open step has no checkbox: "2. Oil it (check: no squeak)."',
            'plans/plan-gadget.md:13 [ADR-REPO-PLANS-OPENSTEP] the open step names no check: "1. [ ] Spin the gadget."'
        )
    }

    It 'requires a plan to have its chunk line in the master and its row in the value overlay' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Write-Plan 'plan-gizmo.md' ($script:goodHead + $script:goodBody)
        $result = Invoke-Gate
        $result.Issues | Should -Be @(
            "plans/plan-gizmo.md:1 [ADR-REPO-PLANS-THREEPARTS] the plan has no chunk line in plan-master.md ('- <chunk> -> plan-gizmo.md: ...')",
            "plans/plan-gizmo.md:1 [ADR-REPO-PLANS-THREEPARTS] the plan has no row in value-of-plan.md ('| <value> | plan-gizmo | ...')"
        )
    }

    It 'reports a step count in the master or the value overlay that differs from the plan''s open steps' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Write-Plan 'plan-master.md' ($script:master[0..16] + @('- widget -> plan-widget.md: three steps,', '  spin it.', '- gadget -> plan-gadget.md: oil it.', '- sprocket -> plan-sprocket.md: turn it.'))
        Write-Plan 'value-of-plan.md' ($script:value[0..3] + @('| medium | plan-widget | 2 steps |', '| low | plan-gadget | one step left |', '| low | plan-sprocket |'))
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Oil (check: no squeak).', '- [x] Done already.'))
        $result = Invoke-Gate
        $result.Issues | Should -Be @(
            'plans/plan-widget.md:1 [ADR-REPO-PLANS-THREEPARTS] its chunk line in plan-master.md says 3 step(s), but the plan has 2 open step(s)'
        )
    }

    It 'finds both overlays missing when the folder has neither file' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Remove-Item -LiteralPath (Join-Path $script:folder 'plan-master.md'), (Join-Path $script:folder 'value-of-plan.md')
        $result = Invoke-Gate
        $result.Issues | Should -HaveCount 2
        $result.Issues | Should -BeLike 'plans/plan-widget.md:1 `[ADR-REPO-PLANS-THREEPARTS`]*'
    }

    It 'holds a task file to its head and its steps, and the master plan to its sections' -Tag 'ADR-REPO-PLANS-MASTERANDTASKS' {
        Write-Plan 'task-oil-gadget.md' @('---', 'task:', '  status: open', '  plans: [plan-widget]', '  value: low', '  targets: [plans]', '---', '', '# Oil the gadget', '', 'no steps')
        Write-Plan 'plan-master.md' @('---', 'plan:', '  status: active', '  value: highest', '  reviewed: 2026-10-17', '  role: master', '  targets: [plans]', '---', '', '# Master', '', '## Chunks')
        $result = Invoke-Gate
        $result.Issues | Should -Contain "plans/task-oil-gadget.md:1 [ADR-REPO-PLANS-MASTERANDTASKS] the task head misses 'blocked_on'"
        $result.Issues | Should -Contain "plans/task-oil-gadget.md:1 [ADR-REPO-PLANS-MASTERANDTASKS] the task file has no '## Steps' section"
        $result.Issues | Should -Contain "plans/plan-master.md:1 [ADR-REPO-PLANS-MASTERANDTASKS] the master plan has no '## Process' section"
    }

    It 'never accepts a numbered task name, and names a line that points at a task by a number' -Tag 'ADR-REPO-PLANS-MASTERANDTASKS', 'ADR-REPO-FOLDERS-STABLEFILENAMES' {
        Write-Plan 'task002.md' $script:task
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Spin after task002 and T003 (check: spins).'))
        $result = Invoke-Gate
        $result.Issues | Should -Contain 'plans/task002.md:1 [ADR-REPO-PLANS-ONETOPICONEFILE] the name is not one the plans folder accepts (plan-<topic>.md, prompt-<topic>-continue.md, task-<topic>.md, …); a name never carries an order (ADR-REPO-FOLDERS-STABLEFILENAMES)'
        $result.Issues | Should -Contain "plans/plan-gadget.md:13 [ADR-REPO-PLANS-MASTERANDTASKS] 'task002' names a task by a number; a task is named by its topic and the master's list carries the order"
        $result.Issues | Should -HaveCount 2
    }

    It 'holds the folder to the roof of task files' -Tag 'ADR-REPO-PLANS-MASTERANDTASKS' {
        Write-Plan 'task-oil-gadget.md' $script:task
        $roof = [Catzc.Base.QualityGates.PlansConfig]::new(@{ tasks = @{ max = 1 } })
        $result = Test-Plans -Path $script:folder -Config $roof -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('plans/task-spin-widget.md:1 [ADR-REPO-PLANS-MASTERANDTASKS] the folder holds more than the roof of 1 task files')
    }

    It 'checks only the plan files -Path names, and still reads the overlays of their folder' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Write-Plan 'plan-gizmo.md' ($script:goodHead + @('# Gizmo', '', '## Open steps', '', '- [ ] Spin.'))
        $result = Test-Plans -Path (Join-Path $script:folder 'plan-widget.md') -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Files'] | Should -Be 1
        $result.Facts['Plans'] | Should -Be 1
    }

    It 'resolves a relative -Path against the repository root, whatever folder the process stands in' {
        Push-Location -LiteralPath $TestDrive
        try {
            $file = Test-Plans -Path 'plans/plan-widget.md' -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
            $folder = Test-Plans -Path 'plans' -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out -PassThru
        }
        finally {
            Pop-Location
        }
        $file.Facts['Files'] | Should -Be 1
        $folder.Facts['Files'] | Should -Be 5
        $folder.IssueCount | Should -Be 0 -Because ($folder.Issues -join "`n")
    }

    It 'throws once listing every issue without -PassThru' {
        Write-Plan 'plan-gadget.md' ($script:goodHead + @('# Gadget', '', '## Open steps', '', '- [ ] Spin.'))
        $thrown = { Test-Plans -Path $script:folder -Config $script:config -RepositoryRoot $script:root -OutputFolder $script:out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Plans failed: 1 issue(s)*'
    }
}
