Describe 'Get-AnalyzerAdrCoverage' -Tag 'L0', 'logic', 'ADR-TEST#28' {
    It 'flattens the map into one pssa-rule row per (analyzer, ADR id)' {
        InModuleScope Catzc.Base.QualityGates {
            Mock Get-Config {
                [ordered]@{ analyzers = [ordered]@{
                        'Measure-FakeRule2' = @('ADR-FAKE#3', 'ADR-FAKE#5')
                        'PSUseFakeRule'     = @('ADR-FAKE#4')
                    }
                }
            } -ParameterFilter { $Config -eq 'analyzer-adr-map' }

            $rows = @(Get-AnalyzerAdrCoverage)
            $rows | Should -HaveCount 3
            ($rows | ForEach-Object Kind | Sort-Object -Unique) | Should -Be 'pssa-rule'
            ($rows | Where-Object { $_.Enforcer -eq 'Measure-FakeRule2' }).AdrId | Should -Be @('ADR-FAKE#3', 'ADR-FAKE#5')
            ($rows | Where-Object { $_.AdrId -eq 'ADR-FAKE#4' }).Enforcer | Should -Be 'PSUseFakeRule'
        }
    }
}

Describe 'analyzer-adr-map integrity' -Tag 'L1', 'integrity', 'ADR-TEST#29' {
    BeforeAll {
        # The shipped map, and the authoritative rule-id set in '#' (citation) form so it compares to the map.
        # Plain assignment receives the comma-wrapped getter result intact — @() would nest it (Show-Cats note).
        $script:map = InModuleScope Catzc.Base.QualityGates { Get-Config -Config analyzer-adr-map }
        $ruleIds = Get-CatsAdrRuleIds
        $script:validIds = [System.Collections.Generic.HashSet[string]]::new(
            [string[]] ($ruleIds -replace ':', '#'), [System.StringComparer]::Ordinal)

        # The custom analyzer rules on disk: every 'Measure-*' function declared under .scriptanalyzer. Read
        # from the files directly (an integrity test reads the tree, not the loaded session — ADR-TEST:16).
        $scriptAnalyzerDir = Resolve-RepoPath 'automation/.scriptanalyzer'
        $script:customRules = [System.Collections.Generic.List[string]]::new()
        foreach ($file in [System.IO.Directory]::EnumerateFiles($scriptAnalyzerDir, '*.psm1')) {
            foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file), '(?m)^\s*function\s+(Measure-\w+)')) {
                $script:customRules.Add($match.Groups[1].Value)
            }
        }
    }

    It 'maps every analyzer to rule ids that resolve to a real ADR rule' {
        # One Should over the violating set — a Should per analyzer × id pays Pester's
        # per-assertion cost times the whole shipped map.
        $violations = foreach ($analyzer in $script:map.analyzers.Keys) {
            foreach ($id in $script:map.analyzers[$analyzer]) {
                if (-not $script:validIds.Contains($id)) {
                    "$analyzer cites $id, which must be a real rule in docs/adr"
                }
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }

    It 'maps every custom analyzer rule (a new one cannot ship unmapped)' {
        $script:customRules.Count | Should -BeGreaterThan 0
        $mapped = @($script:map.analyzers.Keys)
        foreach ($rule in $script:customRules) {
            $mapped | Should -Contain $rule -Because "$rule enforces an ADR rule and must be listed in analyzer-adr-map.yml"
        }
    }
}
