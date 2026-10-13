Describe 'Test-Terminology' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }

        # Default happy path: config loads, dictionary is current, every term is referenced. Both mocks return the
        # production shapes — the typed registry record and Build-TerminologyDictionary's per-category rows.
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.QualityGates.TerminologyConfig]::new([ordered]@{
                    categories = [ordered]@{ widget = [ordered]@{ description = 'widget vocabulary' } }
                    terms      = [ordered]@{
                        widget = @(
                            [ordered]@{ term = 'bicep'; meaning = 'a widget term' }
                            [ordered]@{ term = 'entra'; meaning = 'a widget term' }
                        )
                    }
                })
        }
        Mock Build-TerminologyDictionary -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Category = 'widget'; Path = 'x'; WordCount = 2; Changed = $false; DryRun = $true }
        }
        Mock Get-TerminologyCorpus -ModuleName Catzc.Base.QualityGates { 'bicep entra other content' }
    }

    It 'passes clean when the registry validates, has no drift, and no orphans' {
        $r = Test-Terminology -PassThru
        $r.IssueCount | Should -Be 0
        $r.TermCount | Should -Be 2
    }

    It 'reports drift when the checked-in dictionary is stale (ADR-AUTO-SPELL:5)' {
        Mock Build-TerminologyDictionary -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Category = 'widget'; Path = 'x'; WordCount = 2; Changed = $true; DryRun = $true }
        }
        $r = Test-Terminology -PassThru
        $r.IssueCount | Should -Be 1
        $r.Issues -join "`n" | Should -Match 'drift'
    }

    It 'reports an orphan when a term is not referenced anywhere (ADR-AUTO-SPELL:8)' {
        Mock Get-TerminologyCorpus -ModuleName Catzc.Base.QualityGates { 'bicep only, no second term here' }
        $r = Test-Terminology -PassThru
        $r.IssueCount | Should -Be 1
        $r.Issues -join "`n" | Should -Match "orphan.*'entra'"
    }

    It 'reports a validation failure when the registry does not load (ADR-AUTO-SPELL:6)' {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates { throw 'category is required' }
        $r = Test-Terminology -PassThru
        $r.IssueCount | Should -Be 1
        $r.Issues -join "`n" | Should -Match 'does not validate'
    }

    It 'throws (without -PassThru) when there are issues' {
        Mock Build-TerminologyDictionary -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Category = 'widget'; Path = 'x'; WordCount = 2; Changed = $true; DryRun = $true }
        }
        { Test-Terminology } | Should -Throw '*Test-Terminology failed*'
    }

    It 'writes a report and updates latest.txt' {
        Test-Terminology -PassThru | Out-Null
        $latest = Get-Content (Join-Path $TestDrive 'test-terminology/latest.txt')
        Test-Path (Join-Path $TestDrive "test-terminology/$latest/terminology.md") | Should -BeTrue
    }

    It 'excludes the registry file of the scanned repository tree from the corpus' {
        Test-Terminology -PassThru | Out-Null
        $registry = Join-Path $TestDrive 'automation/Catzc.Base.QualityGates/configs/terminology.yml'
        Should -Invoke Get-TerminologyCorpus -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Root -eq $TestDrive -and $Exclude -contains $registry
        }
    }

    It 'refuses to run outside the source tree (Assert-SourceTree)' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { throw 'operates on the catzc source tree' }
        { Test-Terminology -PassThru } | Should -Throw '*operates on the catzc source tree*'
        Should -Invoke Get-TerminologyCorpus -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

# source-only: it scans the repository's files, which give the same answer in both run modes.
Describe 'Terminology registry integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'the real registry passes every terminology gate (no drift, no orphans, all justified)' {
        { Test-Terminology -OutputFolder (Join-Path $TestDrive 'reports') } | Should -Not -Throw
    }
}
