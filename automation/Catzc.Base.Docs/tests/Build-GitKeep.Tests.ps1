Describe 'Build-GitKeep' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Redirect the repository root to a fixture tree (TestKit) so the walk and the writes bind inside it.
        # One stale .gitkeep, one nested one, one deep inside out/ (must never be touched — the walk checks
        # out/.gitkeep itself but does not descend), and one under a vendored module (not ours to manage).
        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} } -Files @{
            'contracts/.gitkeep'               = "stale`n"
            'pipelines/jobs/.gitkeep'          = ''
            'out/.gitkeep'                     = "stale`n"
            'out/deep/.gitkeep'                = "transient`n"
            'automation/.vendor/Fake/.gitkeep' = "vendored`n"
        }
        $script:expected = [System.IO.File]::ReadAllText(
            (Join-Path (Split-Path $PSScriptRoot -Parent) 'assets/gitkeep'))

        Mock Write-Message -ModuleName Catzc.Base.Docs { }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'rewrites every managed .gitkeep to the generic source content' {
        $report = @(Build-GitKeep -PassThru)
        ($report | Where-Object Path -EQ 'contracts/.gitkeep').Changed | Should -BeTrue
        $written = [System.IO.File]::ReadAllText((Join-Path $script:fake.Root 'contracts/.gitkeep'))
        ($written -replace "`r", '') | Should -Be (($script:expected -replace "`r", '').TrimEnd("`n") + "`n")
    }

    It 'is idempotent: a second run reports every file unchanged' {
        Build-GitKeep | Out-Null
        $report = @(Build-GitKeep -PassThru)
        @($report | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'checks out/.gitkeep itself but never descends into out/ and never touches vendored modules' {
        $report = @(Build-GitKeep -PassThru)
        $report.Path | Should -Contain 'out/.gitkeep'
        $report.Path | Should -Not -Contain 'out/deep/.gitkeep'
        $report.Path | Should -Not -Contain 'automation/.vendor/Fake/.gitkeep'
        [System.IO.File]::ReadAllText((Join-Path $script:fake.Root 'out/deep/.gitkeep')) | Should -Match 'transient'
    }

    It 'writes nothing under -DryRun but reports what would change' {
        $probe = Join-Path $script:fake.Root 'contracts/.gitkeep'
        [System.IO.File]::WriteAllText($probe, "stale again`n")
        $report = @(Build-GitKeep -DryRun -PassThru)
        ($report | Where-Object Path -EQ 'contracts/.gitkeep').Changed | Should -BeTrue
        [System.IO.File]::ReadAllText($probe) | Should -Match 'stale again'
        Build-GitKeep | Out-Null   # restore for the other tests
    }
}

Describe 'Build-GitKeep — managed .gitkeep files' -Tag 'L1', 'integrity' {
    BeforeAll {
        # The real repository's .gitkeep set, discovered by the walk without writing (-DryRun).
        $script:report = @(Build-GitKeep -DryRun -PassThru)
    }

    It 'finds the .gitkeep set and every file carries the generic source content (no drift)' {
        $script:report.Count | Should -BeGreaterThan 0
        @($script:report | Where-Object Changed).Path | Should -BeNullOrEmpty -Because (
            'every .gitkeep is a managed copy of assets/gitkeep — re-run the importer and commit the result')
    }

    It 'every .gitkeep folder is a readme-mapped target — the pointer at README.md must be honest' {
        $mapped = InModuleScope Catzc.Base.Docs {
            @(Get-ReadmeMappings -Config (Get-Config -Config readme)).folder
        }
        $unbacked = foreach ($keep in $script:report.Path) {
            $folder = if ($keep -eq '.gitkeep') {
                '.'
            }
            else {
                $keep -replace '/\.gitkeep$', ''
            }
            if ($folder -notin $mapped) {
                $keep
            }
        }
        @($unbacked) | Should -BeNullOrEmpty -Because (
            'a .gitkeep requires a backing docs/references article mapped in readme.yml — write the article and map the folder, or remove the .gitkeep')
    }
}
