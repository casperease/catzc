<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1
    folder: tests
    name: build-terminology-dictionary-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Build-TerminologyDictionary.Tests.ps1.md
---
#>

Describe 'Build-TerminologyDictionary' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                categories = @('product', 'abbreviation', 'fixture')
                terms      = @(
                    [pscustomobject]@{ term = 'Zebra'; category = 'product' }
                    [pscustomobject]@{ term = 'zebra'; category = 'product' }
                    [pscustomobject]@{ term = 'alpha'; category = 'product' }
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
        ($results | Where-Object Category -EQ 'product').WordCount | Should -Be 2
        ($results | Where-Object Category -EQ 'abbreviation').WordCount | Should -Be 1
        ($results | Where-Object Category -EQ 'fixture').WordCount | Should -Be 1
        ($results | ForEach-Object DryRun) | Should -Not -Contain $false
    }

    It 'reports drift when the fixture registry differs from the generated dictionaries' {
        @(Build-TerminologyDictionary -DryRun -PassThru | Where-Object Changed) | Should -Not -BeNullOrEmpty
    }

    It 'with -DryRun does not modify the generated dictionaries' {
        $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'
        $dicts = 'product', 'abbreviation', 'fixture' |
            ForEach-Object { Join-Path $cspellDir "$_.txt" }
        $before = $dicts | ForEach-Object { [System.IO.File]::ReadAllText($_) }
        Build-TerminologyDictionary -DryRun | Out-Null
        $after = $dicts | ForEach-Object { [System.IO.File]::ReadAllText($_) }
        $after | Should -Be $before
    }
}

Describe 'Build-TerminologyDictionary — real registry' -Tag 'L2', 'integrity', 'source-only' {
    It 'every generated dictionary is current (no drift from the registry)' {
        # The importer regenerates the gitignored dictionaries; the gate names each drifted one.
        $result = Test-GeneratedFiles -Generator Build-TerminologyDictionary -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
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
            @($words | Select-Object -Unique).Count |   # @(): a one-word category unrolls to a scalar
                Should -Be $words.Count -Because "$category is de-duplicated"
            $sorted = [string[]] $words.Clone()
            [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
            $words | Should -Be $sorted -Because "$category is ordinal-sorted (deterministic)"
        }
    }
}
