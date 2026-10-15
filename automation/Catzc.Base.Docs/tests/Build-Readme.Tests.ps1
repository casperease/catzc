<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Build-Readme.Tests.ps1
    kind: test
---
#>

Describe 'Build-Readme' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Isolate through the seams
        # ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): mock the
        # config seam (Get-Config) and redirect the repository
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
        # The fixture repository root is not the loaded code root, which the run-mode guard reads as a built
        # package — the guard is its own seam, asserted separately below.
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
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

    It 'generates a plain-file copy whose links resolve from the README folder, under a meta block and a line naming the source' -Tag 'ADR-REPO-README#6' {
        Build-Readme | Out-Null
        (Get-Item -LiteralPath $script:readme -Force).LinkType | Should -BeNullOrEmpty
        [System.IO.File]::ReadAllText($script:readme) | Should -BeExactly (@(
                '---'
                'catzc:'
                '  derived:'
                '    kind: generated-from-source'
                '---'
                ''
                '# Fixture Title'
                ''
                '> Generated from [docs/references/automation/foo.md](../../docs/references/automation/foo.md) — edit the source;'
                ''
                'Prose with a [sibling link](../../docs/references/automation/catzc-base-asserts.md) that resolves at the source location.'
                ''
            ) -join "`n")
    }

    It 'leaves the source''s front matter, its meta block included, out of the copy' -Tag 'ADR-REPO-README#6' {
        $original = [System.IO.File]::ReadAllText($script:source)
        Build-Readme | Out-Null
        $plain = [System.IO.File]::ReadAllText($script:readme)
        try {
            $framed = "---`ncatzc:`n  derived:`n    kind: reference`n---`n`n" + $original
            [System.IO.File]::WriteAllText($script:source, $framed)
            Build-Readme | Out-Null
            [System.IO.File]::ReadAllText($script:readme) | Should -BeExactly $plain
        }
        finally {
            [System.IO.File]::WriteAllText($script:source, $original)
        }
    }

    It 'rewrites a stale copy' {
        [System.IO.File]::WriteAllText($script:readme, "# Old generated copy`n")

        $result = Build-Readme -PassThru
        $result[0].Changed | Should -BeTrue
        [System.IO.File]::ReadAllText($script:readme) | Should -BeLike '*Generated from*'
    }

    It 'is idempotent — a second run changes nothing' {
        Build-Readme | Out-Null
        $result = Build-Readme -PassThru
        ($result | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'severs a README that is a hard link to its source, leaving the source untouched' {
        $before = [System.IO.File]::ReadAllText($script:source)
        New-Item -ItemType HardLink -Path $script:readme -Target $script:source | Out-Null

        Build-Readme | Out-Null

        [System.IO.File]::ReadAllText($script:source) | Should -BeExactly $before
        [System.IO.File]::ReadAllText($script:readme) | Should -BeLike '*Generated from*'
        (Get-Item -LiteralPath $script:source).LinkType | Should -BeNullOrEmpty -Because 'the source is no longer one of two hard-linked names'
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

    It 'refuses before touching anything when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'Build-Readme operates on the catzc source tree' }
        { Build-Readme } | Should -Throw '*source tree*'
        Test-Path $script:readme | Should -BeFalse
        Should -Invoke Get-Config -ModuleName Catzc.Base.Docs -Times 0
    }
}

# Reads only the repository's readme.yml, folders, and .gitignore — the same answer in both run modes, so the
# build run skips it.
Describe 'Build-Readme — real readme.yml' -Tag 'L2', 'integrity', 'source-only' {
    # The real readme.yml registry is consistent with the repository — every resolved README's source exists
    # (Get-ReadmeContent asserts it), every automation module is covered by the pattern, and the generated/committed
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

    It 'resolves every README without a missing-source throw (Get-ReadmeContent asserts each source exists)' {
        { Build-Readme -DryRun -Silent | Out-Null } | Should -Not -Throw
    }

    It 'every README is current — no drift from readme.yml or its source (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator Build-Readme -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
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
