<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Build-GitKeep.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Build-GitKeep' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} } -Files @{
            'contracts/.gitkeep'                              = "stale`n"
            'pipelines/jobs/.gitkeep'                         = ''
            'out/.gitkeep'                                    = "stale`n"
            'out/deep/.gitkeep'                               = "transient`n"
            "$(Get-CatzcModulesFolder)/.vendor/Fake/.gitkeep" = "vendored`n"
        }
        $script:expected = "This widget folder is kept by a fixture .gitkeep.`n"
        $script:sourcePath = Join-Path $TestDrive 'gitkeep-fixture'
        [System.IO.File]::WriteAllText($script:sourcePath, $script:expected)
        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Docs -ParameterFilter { $ChildPath -eq 'assets/gitkeep' } -MockWith { $script:sourcePath }

        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        # The fake root is no git checkout, so the generated head reads no file as tracked.
        Set-GitTrackedPathMock
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'rewrites every managed .gitkeep to the generic source content under its own generated head' {
        $report = @(Build-GitKeep -PassThru)
        ($report | Where-Object Path -EQ 'contracts/.gitkeep').Changed | Should -BeTrue
        $written = ([System.IO.File]::ReadAllText((Join-Path $script:fake.Root 'contracts/.gitkeep')) -replace "`r", '')
        # The body hash is written only while git tracks the file, so a fixture tree may or may not carry it.
        $written | Should -Match '^# ---\n# catzc:\n#   immutable:\n(#     with_body_sha: "?[0-9a-f]{12}"?\n)?#     warning: "Do Not Edit, this file is generated"\n# ---\n\n'
        $written | Should -BeLike ('*' + ($script:expected -replace "`r", '').TrimEnd("`n") + "`n")
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
        $report.Path | Should -Not -Contain "$(Get-CatzcModulesFolder)/.vendor/Fake/.gitkeep"
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

Describe 'Build-GitKeep — shipped assets/gitkeep' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -WorkingRootOnly -Files @{ 'widgets/.gitkeep' = "stale`n" }
        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        # The fake root is no git checkout, so the generated head reads no file as tracked.
        Set-GitTrackedPathMock
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'writes the content of the asset shipped in the loaded module' {
        Build-GitKeep -Silent | Out-Null
        $shipped = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'assets/gitkeep' -Module Catzc.Base.Docs))
        $written = [System.IO.File]::ReadAllText((Join-Path $script:fake.Root 'widgets/.gitkeep'))
        $shipped.Trim() | Should -Not -BeNullOrEmpty
        ($written -replace "`r", '') | Should -BeLike ('*' + ($shipped -replace "`r", '').TrimEnd("`n") + "`n")
        $written | Should -BeLike '*warning: "Do Not Edit, this file is generated"*'
        $written | Should -Not -BeLike '*role:*'
        $written | Should -Not -BeLike '*path: widgets/.gitkeep*'
    }
}

Describe 'Build-GitKeep — managed .gitkeep files' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        # The real repository's .gitkeep set, discovered by the walk without writing (-DryRun).
        $script:report = @(Build-GitKeep -DryRun -PassThru)
    }

    It 'finds the .gitkeep set and every file carries the generic source content (no drift)' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $script:report.Count | Should -BeGreaterThan 0
        # Every .gitkeep is a managed copy of assets/gitkeep; the gate names each drifted one.
        $result = Test-GeneratedFiles -Generator Build-GitKeep -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
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
