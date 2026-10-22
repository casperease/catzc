Describe 'Update-PlanStepCount' -Tag 'L0', 'logic', 'ADR-REPO-PLANS-THREEPARTS' {
    BeforeAll {
        $script:folder = Join-Path $TestDrive 'plans'
        $script:write = {
            param([string] $Name, [string[]] $Text, [string] $Newline = "`n")
            [System.IO.File]::WriteAllText((Join-Path $script:folder $Name), ($Text -join $Newline) + $Newline)
        }
        $script:read = { param([string] $Name) [System.IO.File]::ReadAllText((Join-Path $script:folder $Name)) }
        $script:update = {
            param([switch] $DryRun)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = $script:folder; DryRun = [bool] $DryRun } {
                param($Folder, $DryRun)
                @(Update-PlanStepCount $Folder -Config ([Catzc.Base.QualityGates.PlansConfig]::new(@{})) -DryRun:$DryRun)
            }
        }
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:folder)) {
            [System.IO.Directory]::Delete($script:folder, $true)
        }
        [void][System.IO.Directory]::CreateDirectory($script:folder)
        & $script:write 'plan-widget.md' @('# Widget', '', '## Open steps', '', '- [ ] Spin it (check: it spins).', '- [ ] Oil it (check: no squeak).')
        & $script:write 'plan-gadget.md' @('# Gadget', '', '## Open steps', '', '- [ ] Turn it (check: it turns).')
        & $script:write 'plan-master.md' @('# Master', '', '## Chunks', '', '- widget -> plan-widget.md: Five steps left, the spin', '- gadget -> plan-gadget.md: the turn,', '  one step left', '- sprocket -> plan-sprocket.md: three steps, no plan file')
        & $script:write 'value-of-plan.md' @('# Value', '', '| Value | Plan | State |', '| --- | --- | --- |', '| medium | plan-widget | open, four steps |', '| low | plan-gadget | one step |')
    }

    It 'rewrites the count of a chunk line and of a value row from the plan''s open steps, keeping the first letter''s case' {
        $changed = & $script:update
        $changed | Should -HaveCount 2
        & $script:read 'plan-master.md' | Should -BeLike '*plan-widget.md: Two steps left, the spin*'
        & $script:read 'value-of-plan.md' | Should -BeLike '*| medium | plan-widget | open, two steps |*'
    }

    It 'leaves a right count, also on a chunk''s continuation line, and a chunk with no plan file as they are' {
        [void] (& $script:update)
        $master = & $script:read 'plan-master.md'
        $master | Should -BeLike "*plan-gadget.md: the turn,`n  one step left*"
        $master | Should -BeLike '*plan-sprocket.md: three steps, no plan file*'
        & $script:read 'value-of-plan.md' | Should -BeLike '*| low | plan-gadget | one step |*'
    }

    It 'reports nothing and writes nothing when every count is right' {
        [void] (& $script:update)
        & $script:update | Should -BeNullOrEmpty
    }

    It 'reports the files a dry run would change, and writes none' {
        $before = & $script:read 'plan-master.md'
        & $script:update -DryRun | Should -HaveCount 2
        & $script:read 'plan-master.md' | Should -BeExactly $before
    }

    It 'keeps a file''s CRLF line ends' {
        & $script:write 'value-of-plan.md' @('| Value | Plan | State |', '| --- | --- | --- |', '| medium | plan-widget | four steps |') "`r`n"
        [void] (& $script:update)
        & $script:read 'value-of-plan.md' | Should -BeExactly "| Value | Plan | State |`r`n| --- | --- | --- |`r`n| medium | plan-widget | two steps |`r`n"
    }
}
