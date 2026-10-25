<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Build-Readme.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Build-Readme' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit

        $sourceText = @(
            '# Fixture Title'
            ''
            'Prose with a [sibling link](catzc-base-asserts.md) that resolves at the source location.'
        ) -join "`n"
        $script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} } -Files @{
            'docs/references/pwsh/foo.md' = ($sourceText + "`n")
        }
        $script:readme = Join-Path $script:fake.Root "$(Get-CatzcModulesFolder)/Catzc.Fixture/README.md"
        $script:source = Join-Path $script:fake.Root 'docs/references/pwsh/foo.md'

        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        # The fake root is no git checkout, so the generated head reads no file as tracked.
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'readme' } {
            [pscustomobject]@{
                patterns = @()
                mappings = @(
                    [pscustomobject]@{ folder = "$(Get-CatzcModulesFolder)/Catzc.Fixture"; source = 'docs/references/pwsh/foo.md' }
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

    It 'generates a plain-file copy whose links resolve from the README folder, under a generated head naming the source' -Tag 'ADR-REPO-README-WORKINGLINKS' {
        Build-Readme | Out-Null
        (Get-Item -LiteralPath $script:readme -Force).LinkType | Should -BeNullOrEmpty
        $text = [System.IO.File]::ReadAllText($script:readme)
        $body = @(
            '# Fixture Title'
            ''
            'Prose with a [sibling link](../../docs/references/pwsh/catzc-base-asserts.md) that resolves at the source location.'
            ''
        ) -join "`n"
        $text | Should -MatchExactly ('^---\ncatzc:\n  immutable:\n(    [^\n]*\n)+---\n\n' + [regex]::Escape($body) + '$')
        $text | Should -BeLike "*`n    warning: `"$((Get-Config -Config generated-head).warning)`"`n*"
        $text | Should -Not -BeLike '*source:*'
        $text | Should -Not -BeLike '*role:*'
        $text | Should -Not -BeLike '*Generated from*'
    }

    It 'leaves the source''s front matter, its meta block included, out of the copy' -Tag 'ADR-REPO-README-WORKINGLINKS' {
        $original = [System.IO.File]::ReadAllText($script:source)
        Build-Readme | Out-Null
        $plain = [System.IO.File]::ReadAllText($script:readme)
        try {
            $framed = "---`ncatzc:`n  immutable:`n    role: reference`n---`n`n" + $original
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
        [System.IO.File]::ReadAllText($script:readme) | Should -BeLike '*    warning: *'
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
        [System.IO.File]::ReadAllText($script:readme) | Should -BeLike '*    warning: *'
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
        { Build-Readme -Folder 'widgets/Nope' } | Should -Throw '*No README mapping*'
    }

    It 'refuses before touching anything when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'Build-Readme operates on the catzc source tree' }
        { Build-Readme } | Should -Throw '*source tree*'
        Test-Path $script:readme | Should -BeFalse
        Should -Invoke Get-Config -ModuleName Catzc.Base.Docs -Times 0
    }
}

Describe 'Build-Readme — real readme.yml' -Tag 'L2', 'integrity', 'source-only' {
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
        $modulesFolder = Get-CatzcModulesFolder
        $modules = @([System.IO.Directory]::EnumerateDirectories((Get-CatzcModulesRoot)) |
                ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Where-Object { -not $_.StartsWith('.') })
        $mapped = @($script:results.Folder)
        $violations = foreach ($module in $modules) {
            if ("$modulesFolder/$module" -notin $mapped) {
                "$modulesFolder/$module has no docs/references/pwsh/<kebab>.md reference article"
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
