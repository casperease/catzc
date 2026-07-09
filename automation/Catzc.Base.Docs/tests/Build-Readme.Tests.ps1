Describe 'Build-Readme' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Isolate through the seams (ADR-AUTO-PESTER:2): mock the config seam (Get-Config) and redirect the repository
        # root to a fixture tree (TestKit) so Resolve-RepoPath binds inside it.
        $sourceText = @(
            '# Fixture Title'
            ''
            'Prose with a [sibling link](catzc-base-asserts.md) that resolves at the source location.'
        ) -join "`n"
        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} } -Files @{
            'docs/references/automation/foo.md' = ($sourceText + "`n")
        }
        $script:readme = Join-Path $script:fake.Root 'automation/Catzc.Fixture/README.md'
        $script:source = Join-Path $script:fake.Root 'docs/references/automation/foo.md'

        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        Mock Get-Config -ModuleName Catzc.Base.Docs {
            [pscustomobject]@{
                patterns = @()
                mappings = @(
                    [pscustomobject]@{ folder = 'automation/Catzc.Fixture'; source = 'docs/references/automation/foo.md' }
                )
            }
        }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Remove-Item $script:readme -Force -ErrorAction Ignore
    }

    It 'materialises the README as a link whose content IS the source' {
        Build-Readme | Out-Null
        (Get-Item -LiteralPath $script:readme -Force).LinkType | Should -Not -BeNullOrEmpty
        [System.IO.File]::ReadAllText($script:readme) |
            Should -Be ([System.IO.File]::ReadAllText($script:source))
    }

    It 'replaces a plain file (the old generated copy) with a link' {
        [System.IO.File]::WriteAllText($script:readme, "# Old generated copy`n")

        $result = Build-Readme -PassThru
        $result[0].Changed | Should -BeTrue
        (Get-Item -LiteralPath $script:readme -Force).LinkType | Should -Not -BeNullOrEmpty
    }

    It 'is idempotent — a second run changes nothing' {
        Build-Readme | Out-Null
        $result = Build-Readme -PassThru
        ($result | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'an edit through the README path lands in the source' {
        Build-Readme | Out-Null
        [System.IO.File]::WriteAllText($script:readme, "# Edited through the README`n")
        [System.IO.File]::ReadAllText($script:source) | Should -Be "# Edited through the README`n"

        # Restore the fixture source for the sibling tests.
        [System.IO.File]::WriteAllText($script:source, "# Fixture Title`n")
    }

    It 'with -DryRun does not write a missing README' {
        Build-Readme -DryRun | Out-Null
        Test-Path $script:readme | Should -BeFalse
    }

    It 'reports the change with -DryRun -PassThru without writing' {
        $result = Build-Readme -DryRun -PassThru
        @($result).Count | Should -Be 1
        $result[0].Changed | Should -BeTrue
        $result[0].DryRun | Should -BeTrue
        Test-Path $script:readme | Should -BeFalse
    }

    It 'throws when -Folder matches no mapping' {
        { Build-Readme -Folder 'automation/Nope' } | Should -Throw '*No README mapping*'
    }
}

Describe 'Build-Readme — real readme.yml' -Tag 'L2', 'integrity' {
    # The real readme.yml registry is consistent with the repository — every resolved README's source exists
    # (Set-FileLink asserts it), every automation module is covered by the pattern, and the generated/committed
    # split matches .gitignore (every mapped README is ignored; none is opted back in). Resolves through the
    # public generator (Build-Readme -DryRun -PassThru) since the pattern expansion (Get-ReadmeMappings) is
    # private. Closes the poka-yoke gap of the two-place "generated vs committed" convention (readme.yml <->
    # .gitignore).
    BeforeAll {
        $script:root = Get-RepositoryRoot
        $script:results = @(Build-Readme -DryRun -PassThru -Silent)
        $script:gitignoreLines = Get-Content (Join-Path $script:root '.gitignore')
        $script:optOuts = @(
            $script:gitignoreLines |
                Where-Object { $_ -match '^!.*README\.md$' } |
                ForEach-Object { $_.Substring(1) }
        )
    }

    It 'resolves every README without a missing-source throw (Set-FileLink asserts each source exists)' {
        { Build-Readme -DryRun -Silent | Out-Null } | Should -Not -Throw
    }

    It 'covers every automation module — the pattern derives a reference article for each' {
        $automationRoot = Join-Path $script:root 'automation'
        $modules = @([System.IO.Directory]::EnumerateDirectories($automationRoot) |
                ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Where-Object { -not $_.StartsWith('.') })
        $mapped = @($script:results.Folder)
        # One Should over the violating set — a Should per module pays Pester's per-assertion cost
        # times the whole automation tree.
        $violations = foreach ($module in $modules) {
            if ("automation/$module" -notin $mapped) {
                "automation/$module has no docs/references/automation/<kebab>.md reference article"
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }

    It 'declares the global README ignore rule' {
        ($script:gitignoreLines -contains '**/README.md') |
            Should -BeTrue -Because 'generated READMEs are ignored globally'
    }

    It 'ignores every generated (mapped) README — none is opted back in' {
        foreach ($result in $script:results) {
            $target = "$($result.Folder)/README.md"
            $target |
                Should -Not -BeIn $script:optOuts -Because "$target is generated and must stay gitignored"
        }
    }
}
