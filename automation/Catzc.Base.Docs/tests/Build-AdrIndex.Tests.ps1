Describe 'Build-AdrIndex — generated ADR index' -Tag 'L1', 'integrity', 'ADR-REPO-README#7' {
    BeforeAll {
        # The importer's janitor tail materialised docs/adr/index.md before this run; check it without writing.
        $script:report = Build-AdrIndex -DryRun -PassThru
        $script:indexEntries = & (Get-Module Catzc.Base.Docs) { Get-CatsAdrIndex }
        $script:ruleSets = Get-AdrRuleSet
        $script:adrRoot = Resolve-RepoPath 'docs/adr'
    }

    It 'the on-disk index is current — no drift from adrs.yml' {
        $script:report.Changed | Should -BeFalse -Because (
            'docs/adr/index.md is generated from adrs.yml (Build-AdrIndex) — re-run the importer to regenerate it')
    }

    It 'every adrs.yml ruleset is one parseable index row (codes agree with the flattened rule-sets)' {
        (@($script:indexEntries.Code) | Sort-Object) -join ',' |
            Should -Be ((@($script:ruleSets.External) | Sort-Object) -join ',') -Because (
                'the index is a projection of adrs.yml — every external code is one row, in the format Get-CatsAdrIndex parses')
    }

    It 'every index row links to a real ADR file under its domain folder' {
        $missing = foreach ($entry in $script:indexEntries) {
            $full = Join-Path $script:adrRoot $entry.Path
            if (-not [System.IO.File]::Exists($full)) {
                "$($entry.Code) -> $($entry.Path)"
            }
        }
        @($missing) | Should -BeNullOrEmpty -Because 'each generated link resolves to the ADR markdown it cites'
    }
}
