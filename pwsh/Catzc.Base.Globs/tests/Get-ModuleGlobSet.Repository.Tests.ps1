Describe 'Repository unit aspects (every laid-out unit)' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:gitMissing = -not (Get-Command git -ErrorAction Ignore)
        if (-not $script:gitMissing) {
            $script:files = @(Get-GitTrackedPath .)
            $script:optional = (Get-Config -Config globs).tests_optional
            $script:testSets = @(Get-ModuleGlobSet | Where-Object { $_.Name -like '*-tests' })
        }
    }

    It 'derives a tests set for the units it lays out' -Tag 'DDR-ASPECT-ASPECTSAREDERIVED' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $script:testSets.Count | Should -BeGreaterThan 0
    }

    It 'claims at least one tracked file in each unit''s tests set, a unit config marks optional excepted' -Tag 'DDR-ASPECT-PARTITIONISCHECKED' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $untested = foreach ($set in $script:testSets) {
            if ($script:optional.ContainsKey($set.Name)) {
                continue
            }
            $claimed = $false
            foreach ($file in $script:files) {
                if ($set.Matches($file)) {
                    $claimed = $true
                    break
                }
            }
            if (-not $claimed) {
                $set.Name
            }
        }
        @($untested) |
            Should -BeNullOrEmpty -Because 'a unit with no test proves nothing; add its tests, or name it under tests_optional in globs.yml with its reason'
    }

    It 'names under tests_optional only units that have a tests set' -Tag 'DDR-ASPECT-ASPECTSAREDERIVED' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $known = @($script:testSets | ForEach-Object Name)
        @($script:optional.Keys | Where-Object { $_ -cnotin $known }) |
            Should -BeNullOrEmpty -Because 'an exemption for a unit that no longer exists is stale'
    }
}
