Describe 'Build-Readme' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        # Isolate through the seams (ADR-TEST:2): mock the config seam (Get-Config) and redirect the repository
        # root to a fixture tree (TestKit) so Resolve-RepoPath and the link rebaser bind inside it.
        # H1, a blank line (exercises the double-blank guard, MD012), then a sibling link and a parent link
        # (exercise the rebaser) and an in-page anchor (must be left alone).
        $sourceText = @(
            '# Fixture Title'
            ''
            'See [asserts](catzc-base-asserts.md) and [pwd](../../adr/automation/never-depend-on-pwd.md).'
            'Jump to [top](#fixture-title).'
        ) -join "`n"
        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} } -Files @{
            'docs/references/automation/foo.md' = ($sourceText + "`n")
        }
        $script:readme = Join-Path $script:fake.Root 'automation/Catzc.Fixture/README.md'

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

    It 'generates the README with the banner injected after the H1' {
        Build-Readme | Out-Null
        Test-Path $script:readme | Should -BeTrue
        $text = [System.IO.File]::ReadAllText($script:readme)
        ($text -split "`n")[0] | Should -Be '# Fixture Title'
        $text | Should -Match '> ⚠️ \*\*Warning'
        $text | Should -Match '`docs/references/automation/foo\.md`'
    }

    It 'rebases relative links to the target folder and leaves the anchor' {
        Build-Readme | Out-Null
        $text = [System.IO.File]::ReadAllText($script:readme)
        $text | Should -Match '\[asserts\]\(\.\./\.\./docs/references/automation/catzc-base-asserts\.md\)'
        $text | Should -Match '\[pwd\]\(\.\./\.\./docs/adr/automation/never-depend-on-pwd\.md\)'
        $text | Should -Match '\[top\]\(#fixture-title\)'
    }

    It 'produces no double blank line (MD012-clean) and a single trailing newline' {
        Build-Readme | Out-Null
        $text = [System.IO.File]::ReadAllText($script:readme)
        $text | Should -Not -Match "`n`n`n"
        $text.EndsWith("`n") | Should -BeTrue
        $text.EndsWith("`n`n") | Should -BeFalse
    }

    It 'is idempotent — a second run rewrites nothing' {
        Build-Readme | Out-Null
        $result = Build-Readme -PassThru
        ($result | Where-Object Changed) | Should -BeNullOrEmpty
    }

    It 'skips a rewrite when only the line endings differ (EOL-insensitive)' {
        Build-Readme | Out-Null
        $lf = [System.IO.File]::ReadAllText($script:readme)
        $crlf = $lf -replace "`n", "`r`n"
        [System.IO.File]::WriteAllText($script:readme, $crlf, [System.Text.UTF8Encoding]::new($false))
        $result = Build-Readme -PassThru
        ($result | Where-Object Changed) |
            Should -BeNullOrEmpty -Because 'a pure CRLF/LF difference is not a content change'
    }

    It 'with -DryRun does not write a missing README' {
        Remove-Item $script:readme -Force -ErrorAction Ignore
        Build-Readme -DryRun | Out-Null
        Test-Path $script:readme | Should -BeFalse
    }

    It 'reports the change with -DryRun -PassThru without writing' {
        Remove-Item $script:readme -Force -ErrorAction Ignore
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

Describe 'Update-MarkdownRelativeLink' -Tag 'L0', 'logic' {
    It 'rebases parent-relative and sibling links; leaves anchors and URLs' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $TestDrive } {
            param($Root)
            $content = @(
                '[pwd](../../adr/automation/never-depend-on-pwd.md)'
                '[files](catzc-base-files.md)'
                '[anchor](#domain1--x)'
                '[web](https://example.com/x.md)'
            ) -join "`n"
            $out = Update-MarkdownRelativeLink -Content $content `
                -SourceDirectory 'docs/references/automation' `
                -TargetDirectory 'automation/Catzc.Base.Repository' `
                -RepositoryRoot $Root
            $lines = $out -split "`n"
            $lines[0] | Should -Be '[pwd](../../docs/adr/automation/never-depend-on-pwd.md)'
            $lines[1] | Should -Be '[files](../../docs/references/automation/catzc-base-files.md)'
            $lines[2] | Should -Be '[anchor](#domain1--x)'
            $lines[3] | Should -Be '[web](https://example.com/x.md)'
        }
    }

    It 'preserves a #fragment and an optional title when rebasing' {
        InModuleScope Catzc.Base.Docs -Parameters @{ Root = $TestDrive } {
            param($Root)
            $out = Update-MarkdownRelativeLink -Content '[x](../../adr/repository/api-contracts.md#rule-adr-contract2 "Contracts")' `
                -SourceDirectory 'docs/references/automation' `
                -TargetDirectory 'automation/Catzc.Azure' `
                -RepositoryRoot $Root
            $out | Should -Be '[x](../../docs/adr/repository/api-contracts.md#rule-adr-contract2 "Contracts")'
        }
    }
}

Describe 'Build-Readme — real readme.yml' -Tag 'L2', 'integrity' {
    # The real readme.yml registry is consistent with the repository — every resolved README's source exists
    # (Build-Readme asserts it), every automation module is covered by the pattern, and the generated/committed
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

    It 'resolves every README without a missing-source throw (Build-Readme asserts each source exists)' {
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
