Describe 'Build-AdrIndex — generated ADR index' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-README#7' {
    BeforeAll {
        $script:indexEntries = & (Get-Module Catzc.Base.Docs) { Get-CatsAdrIndex }
        $script:ruleSets = Get-AdrRuleSet
        $script:adrRoot = Resolve-RepoPath 'docs/adr'
    }

    It 'the on-disk index is current — no drift from adrs.yml (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator Build-AdrIndex -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'the on-disk index carries the stamp of the inputs it is built from, so an unchanged build is skipped' {
        Build-AdrIndex -Silent | Out-Null
        $head = [System.IO.File]::ReadAllText((Join-Path $script:adrRoot 'index.md'))
        $head | Should -Match 'with_inputs_sha: "?[0-9a-f]{64}'
        (Build-AdrIndex -Silent -PassThru).Changed | Should -BeFalse
    }

    It 'every adrs.yml ruleset is one parseable index row (codes agree with the flattened rule-sets)' {
        (@($script:indexEntries.Code) | Sort-Object) -join ',' |
            Should -Be ((@($script:ruleSets.External) | Sort-Object) -join ',') -Because (
                'the index is a projection of adrs.yml — every external code is one row, in the format Get-CatsAdrIndex parses')
    }

    It 'every domain heading is followed by its adrs.yml description' {
        $index = [System.IO.File]::ReadAllText((Join-Path $script:adrRoot 'index.md'))
        $flattened = $index -replace '\s+', ' '
        $missing = foreach ($domain in (Get-Config -Config adrs).Domains) {
            $expected = "### $($domain.Name)/ $($domain.Description -replace '\s+', ' ')"
            if (-not $flattened.Contains($expected)) {
                $domain.Name
            }
        }
        @($missing) | Should -BeNullOrEmpty -Because 'each domain section opens with the description declared in adrs.yml'
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

Describe 'Build-AdrIndex — shipped configs/adrs.yml and types' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    It 'finds the domain registry and the type sources it stamps in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/adrs.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
        [System.IO.Directory]::EnumerateFiles((Get-CatzcModuleRoot 'types' -Module Catzc.Base.Docs), '*.cs') | Should -Not -BeNullOrEmpty
    }
}
