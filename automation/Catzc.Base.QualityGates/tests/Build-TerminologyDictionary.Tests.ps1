Describe 'Build-TerminologyDictionary' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        # A tiny registry spanning all three categories, with a duplicate and mixed case in the domain
        # category, to prove per-category grouping plus lower-casing + de-duplication.
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                categories = @('domain', 'abbreviation', 'fixture')
                terms      = @(
                    [pscustomobject]@{ term = 'Zebra'; category = 'domain' }
                    [pscustomobject]@{ term = 'zebra'; category = 'domain' }
                    [pscustomobject]@{ term = 'alpha'; category = 'domain' }
                    [pscustomobject]@{ term = 'ctx'; category = 'abbreviation' }
                    [pscustomobject]@{ term = 'smpl'; category = 'fixture' }
                )
            }
        }
    }

    It 'emits one result per category, grouping the distinct lower-cased terms' {
        # -DryRun only: a real write would overwrite the checked-in dictionaries with this fixture set.
        $results = Build-TerminologyDictionary -DryRun -PassThru
        @($results).Count | Should -Be 3
        ($results | Where-Object Category -EQ 'domain').WordCount | Should -Be 2
        ($results | Where-Object Category -EQ 'abbreviation').WordCount | Should -Be 1
        ($results | Where-Object Category -EQ 'fixture').WordCount | Should -Be 1
        ($results | ForEach-Object DryRun) | Should -Not -Contain $false
    }

    It 'reports drift when the fixture registry differs from the generated dictionaries' {
        @(Build-TerminologyDictionary -DryRun -PassThru | Where-Object Changed) | Should -Not -BeNullOrEmpty
    }

    It 'with -DryRun does not modify the generated dictionaries' {
        $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'
        $dicts = 'domain', 'abbreviation', 'fixture' |
            ForEach-Object { Join-Path $cspellDir "$_.txt" }
        $before = $dicts | ForEach-Object { [System.IO.File]::ReadAllText($_) }
        Build-TerminologyDictionary -DryRun | Out-Null
        $after = $dicts | ForEach-Object { [System.IO.File]::ReadAllText($_) }
        $after | Should -Be $before
    }
}

Describe 'Build-TerminologyDictionary — real registry' -Tag 'L2', 'integrity' {
    It 'every generated dictionary is current (no drift from the registry)' {
        @(Build-TerminologyDictionary -DryRun -PassThru | Where-Object Changed) |
            Should -BeNullOrEmpty -Because 'the importer regenerates the gitignored dictionaries; re-run . ./importer.ps1'
    }

    It 'each generated dictionary is lower-cased, unique, and ordinal-sorted' {
        $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'
        foreach ($category in (Get-Config -Config terminology).categories) {
            $dict = Join-Path $cspellDir "$category.txt"
            # Skip the generated-file header (cspell '#' comment lines) and blanks; keep the word lines.
            $words = [string[]] @(([System.IO.File]::ReadAllText($dict) -replace "`r`n", "`n") -split "`n" |
                    Where-Object { $_ -and -not $_.StartsWith('#') })
            $lower = @($words | ForEach-Object { $_.ToLowerInvariant() })
            $words | Should -Be $lower -Because "$category is lower-cased"
            ($words | Select-Object -Unique).Count |
                Should -Be $words.Count -Because "$category is de-duplicated"
            $sorted = [string[]] $words.Clone()
            [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
            $words | Should -Be $sorted -Because "$category is ordinal-sorted (deterministic)"
        }
    }
}
