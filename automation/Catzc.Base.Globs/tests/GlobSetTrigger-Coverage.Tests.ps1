# Coverage of the native-trigger projection over THIS repo's real tree (ADR-GLOBS:1). The guaranteed safety
# property: every member of a pipeline-bound set matches at least one ADO include pattern — so an ADO
# include-only trigger is always a SUPERSET of exact membership and can never under-trigger (miss a deploy);
# the in-pipeline Test-GlobSetAffected gate supplies exactness on top. (GitHub is exact by construction: its
# ordered '!'-negation paths ARE the scan program, the same evaluator as GlobSet.Matches — covered at L0.)
Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity' {
    BeforeDiscovery {
        $script:boundSets = @(Get-GlobSet | Where-Object Pipeline | ForEach-Object Name)
    }

    It 'ADO includes cover every member of <_> (include-only is a safe superset)' -ForEach $boundSets {
        $trigger = Get-GlobSetTrigger -Name $_
        $includes = foreach ($pattern in $trigger.AdoInclude) {
            [Catzc.Base.Globs.GlobPattern]::new($pattern)
        }

        $uncovered = foreach ($member in (Get-GlobSetFile -Name $_)) {
            $covered = $false
            foreach ($include in $includes) {
                if ($include.Matches($member)) {
                    $covered = $true
                    break
                }
            }
            if (-not $covered) {
                $member
            }
        }

        @($uncovered) | Should -BeNullOrEmpty -Because "every member of '$_' must match an ADO include pattern"
    }
}
