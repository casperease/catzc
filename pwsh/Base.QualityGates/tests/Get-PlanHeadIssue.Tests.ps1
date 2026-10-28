Describe 'Get-PlanHeadIssue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widgets'))
        $script:config = [Catzc.Base.QualityGates.PlansConfig]::new(@{})
        $script:issues = {
            param($FrontMatter)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $FrontMatter; C = $script:config; R = $script:root } {
                param($F, $C, $R)
                @(Get-PlanHeadIssue -FrontMatter $F -Config $C -RepositoryRoot $R)
            }
        }
        $script:head = {
            param([System.Collections.IDictionary] $Extra = @{})
            $plan = [ordered]@{ status = 'active'; value = 'high'; reviewed = '2026-10-28'; targets = @('widgets') }
            foreach ($key in $Extra.Keys) {
                $plan[$key] = $Extra[$key]
            }
            [ordered]@{ plan = $plan }
        }
    }

    It 'passes a head that holds every required key with known values' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        & $script:issues (& $script:head) | Should -BeNullOrEmpty
    }

    It 'reports a missing front matter and a head without the plan block' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        & $script:issues $null | Should -Be @("the head has no 'plan:' block")
        & $script:issues ([ordered]@{ task = @{} }) | Should -Be @("the head has no 'plan:' block")
    }

    It 'reports a missing key and a foreign key' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        $front = & $script:head @{ colour = 'blue' }
        $front['plan'].Remove('reviewed')
        $found = & $script:issues $front
        $found | Should -Contain "the head misses 'reviewed'"
        $found | Should -Contain "the head key 'colour' is outside the plan keys ($(($script:config.head_required + $script:config.head_allowed) -join ', '))"
    }

    It 'reports a bad status, a bad rank and a blocked plan that names no blocker' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        & $script:issues (& $script:head @{ status = 'pending'; value = 'huge' }) |
            Should -Be @("status 'pending' is not one of: $($script:config.statuses -join ', ')",
                "value 'huge' is not one of the ranks: $($script:config.ranks -join ', ')")
        & $script:issues (& $script:head @{ status = 'blocked' }) |
            Should -Be @("a blocked plan names what blocks it in 'blocked_on' or 'waits_on'")
        & $script:issues (& $script:head @{ status = 'blocked'; waits_on = 'gadget' }) | Should -BeNullOrEmpty
    }

    It 'reports an empty targets list and a target that does not exist' -Tag 'ADR-REPO-PLANS-PLANHEAD' {
        & $script:issues (& $script:head @{ targets = @() }) | Should -Be @('targets names no path')
        & $script:issues (& $script:head @{ targets = @('widgets', 'nowhere') }) | Should -Be @("target 'nowhere' does not exist")
    }
}
