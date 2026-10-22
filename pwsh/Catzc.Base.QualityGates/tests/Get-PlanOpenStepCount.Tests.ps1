<#
---
catzc:
  immutable:
    with_body_sha: ff03fd7d560f
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-PlanOpenStepCount.ps1
    cites:
      - ADR-REPO-PLANS-THREEPARTS
---
#>

Describe 'Get-PlanOpenStepCount' -Tag 'L0', 'logic', 'ADR-REPO-PLANS-THREEPARTS' {
    BeforeAll {
        $script:folder = Join-Path $TestDrive 'plans'
        [void][System.IO.Directory]::CreateDirectory($script:folder)
        $write = {
            param([string] $Name, [string[]] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:folder $Name), ($Text -join "`n") + "`n")
        }
        & $write 'plan-widget.md' @('# Widget', '', '## Open steps', '', '- [ ] Spin it (check: it spins).', '- [ ] Oil it,', '      one drop (check: no squeak).', '- [x] Polished.')
        & $write 'plan-gadget.md' @('# Gadget', '', '## Open steps', '', '1. [ ] Turn it (check: it turns).')
        & $write 'plan-master.md' @('# Master', '', '- [ ] Not a plan step.')
        & $write 'task-widget.md' @('# Task', '', '- [ ] Not a plan either.')
        $script:count = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Folder = $script:folder } {
                param($Folder)
                Get-PlanOpenStepCount $Folder -Config ([Catzc.Base.QualityGates.PlansConfig]::new(@{}))
            }
        }
    }

    It 'counts the open steps of every plan, a wrapped or numbered step once, a done step never' {
        $counts = & $script:count
        $counts['plan-widget.md'] | Should -Be 2
        $counts['plan-gadget.md'] | Should -Be 1
    }

    It 'leaves out the master, the tasks and every file that is not a plan, and keeps ordinal order' {
        @((& $script:count).Keys) | Should -Be @('plan-gadget.md', 'plan-widget.md')
    }
}
