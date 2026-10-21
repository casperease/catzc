<#
---
catzc:
  immutable:
    with_body_sha: b745b43b4500
  edges:
    code: pwsh/Catzc.Base.QualityGates/New-Plan.ps1
    cites:
      - ADR-REPO-PLANS-THREEPARTS
---
#>

Describe 'New-Plan' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:config = [Catzc.Base.QualityGates.PlansConfig]::new(@{})
        function Invoke-NewPlan {
            param([string] $Topic = 'spin-widget', [string] $Value = 'medium', [string[]] $Target = @('widgets'), [string] $Class = 'feature')
            New-Plan -Topic $Topic -Value $Value -Class $Class -Target $Target -Summary 'the widget spins' -Config $script:config -RepositoryRoot $script:root
        }
        $script:plans = Join-Path $script:root '.claude/plans'
        $script:value = @('# Value', '', '## Meta plans by value', '', '| Value | Plan | Why | State |', '| --- | --- | --- | --- |', '| high | plan-master | the order | live |', '', '## Feature plans', '', '| Value | Plan | Needed docs | State |', '| --- | --- | --- | --- |', '', '## Pending deletion', '')
        $script:master = @('# Master', '', '## Process', '', 'rules', '', '## Chunks', '', 'Open, in order.', '', '- oil-gadget -> plan-oil-gadget.md: oil it,', '  one drop.', '- user-runs -> task-user-runs.md: the user''s steps.', '', 'A new plan adds its line.', '')
    }

    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        if (Test-Path -LiteralPath $script:root) {
            Remove-Item -LiteralPath $script:root -Recurse -Force
        }
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widgets'))
        [void][System.IO.Directory]::CreateDirectory($script:plans)
        [System.IO.File]::WriteAllText((Join-Path $script:plans 'value-of-plan.md'), ($script:value -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $script:plans 'plan-master.md'), ($script:master -join "`n"))
    }

    It 'adds the value row to the table of the plan''s class, one cell per column' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Invoke-NewPlan | Out-Null
        Invoke-NewPlan -Topic 'oil-gadget' -Value 'low' -Class 'meta' | Out-Null
        $lines = [System.IO.File]::ReadAllText((Join-Path $script:plans 'value-of-plan.md')) -split "`n"
        $lines[7] | Should -BeExactly '| low | plan-oil-gadget | the widget spins | new |'
        $lines[13] | Should -BeExactly '| medium | plan-spin-widget |  | new |'
        $lines[15] | Should -BeExactly '## Pending deletion'
    }

    It 'adds the master line ahead of the task pointers, after the plan items and their continuation lines' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        Invoke-NewPlan | Out-Null
        $lines = [System.IO.File]::ReadAllText((Join-Path $script:plans 'plan-master.md')) -split "`n"
        $lines[10..13] | Should -Be @('- oil-gadget -> plan-oil-gadget.md: oil it,', '  one drop.', '- spin-widget -> plan-spin-widget.md: the widget spins', '- user-runs -> task-user-runs.md: the user''s steps.')
    }

    It 'refuses a class the value overlay has no section for, and writes nothing' -Tag 'ADR-REPO-PLANS-THREEPARTS' {
        { Invoke-NewPlan -Class 'gizmo' } | Should -Throw "*no '## gizmo plans' section*"
        Join-Path $script:plans 'plan-spin-widget.md' | Should -Not -Exist
        [System.IO.File]::ReadAllText((Join-Path $script:plans 'plan-master.md')) | Should -BeExactly ($script:master -join "`n")
    }

    It 'writes the head and the open steps section, and returns the file' {
        $file = Invoke-NewPlan
        $file | Should -BeExactly (Join-Path (Join-Path $script:root '.claude/plans') 'plan-spin-widget.md')
        $text = [System.IO.File]::ReadAllText($file)
        $head = "---`nplan:`n  status: active`n  value: medium`n  reviewed: $([DateTime]::Today.ToString('yyyy-MM-dd'))`n  class: feature`n  targets: [widgets]`n---`n"
        $text.StartsWith($head, [System.StringComparison]::Ordinal) | Should -BeTrue -Because $text
        $text | Should -BeLike "*`n# Spin widget`n`n## Open steps`n"
    }

    It 'writes a plan Test-Plans passes' {
        $file = Invoke-NewPlan
        $result = Test-Plans -Path ([System.IO.Path]::GetDirectoryName($file)) -Config $script:config -RepositoryRoot $script:root -OutputFolder (Join-Path $TestDrive 'out') -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'refuses a topic whose plan exists, and leaves it as it was' {
        $file = Invoke-NewPlan
        [System.IO.File]::WriteAllText($file, "kept`n")
        { Invoke-NewPlan } | Should -Throw '*exists; a topic has one plan*'
        [System.IO.File]::ReadAllText($file) | Should -BeExactly "kept`n"
    }

    It 'refuses <case>' -ForEach @(
        @{ case = 'a name the folder does not accept'; Topic = 'Spin_Widget'; Value = 'medium'; Target = @('widgets'); expect = '*not a plan name*' }
        @{ case = 'the master plan''s name'; Topic = 'master'; Value = 'medium'; Target = @('widgets'); expect = '*not a plan name*' }
        @{ case = 'a value outside the ranks'; Topic = 'spin-widget'; Value = 'urgent'; Target = @('widgets'); expect = '*not one of the ranks*' }
        @{ case = 'a target that does not exist'; Topic = 'spin-widget'; Value = 'medium'; Target = @('gadgets'); expect = '*target ''gadgets'' does not exist*' }
    ) {
        { Invoke-NewPlan -Topic $Topic -Value $Value -Target $Target } | Should -Throw $expect
    }
}
