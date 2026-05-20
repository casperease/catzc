Describe 'New-SyntheticHistory' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:repo = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-synth-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        New-Item -ItemType Directory -Path $script:repo -Force | Out-Null
        $repo = $script:repo

        & git -C $repo init -b main *> $null
        & git -C $repo config user.email 'seed@example.com' *> $null
        & git -C $repo config user.name 'Seed' *> $null
        & git -C $repo config commit.gpgsign false *> $null

        # An old history that mentions a token in a blob and a message, then removed from the tree.
        Set-Content -Path (Join-Path $repo 'leak.txt') -Value 'contains old-secret token'
        & git -C $repo add -A *> $null
        & git -C $repo commit -m 'seed with old-secret' *> $null

        # The current working tree — clean of the token, laid out for the layers below.
        Remove-Item (Join-Path $repo 'leak.txt')
        New-Item -ItemType Directory -Path (Join-Path $repo 'core/tests') -Force | Out-Null
        New-Item -ItemType Directory -Path (Join-Path $repo 'docs') -Force | Out-Null
        Set-Content -Path (Join-Path $repo 'core/a.txt') -Value 'core code'
        Set-Content -Path (Join-Path $repo 'core/tests/t.txt') -Value 'core test'
        Set-Content -Path (Join-Path $repo 'docs/readme.md') -Value '# docs'

        $script:layers = @(
            @{ Message = 'Add core'; Include = @('core'); Exclude = @(':(exclude)core/tests') }
            @{ Message = 'Add core tests'; Include = @('core/tests'); Exclude = @() }
            @{ Message = 'Add docs'; Include = @('docs'); Exclude = @() }
            @{ Message = 'Everything else'; Include = @('.'); Exclude = @() }
        )
        $script:result = New-SyntheticHistory -Layer $script:layers -RepositoryPath $repo `
            -AuthorName 'A Dev' -AuthorEmail 'a@dev.test' `
            -SpanStart ([datetime]'2024-01-01') -SpanEnd ([datetime]'2024-03-01')
    }

    AfterAll {
        if ($script:repo -and (Test-Path $script:repo)) {
            Remove-Item -Recurse -Force $script:repo -ErrorAction SilentlyContinue
        }
    }

    It 'commits one layer per non-empty spec (the catch-all was empty)' {
        $script:result.CommitCount | Should -Be 3
    }

    It 'produces a single-author history' {
        $authors = @(& git -C $script:repo log --format='%an' | Sort-Object -Unique)
        $authors.Count | Should -Be 1
        $authors[0] | Should -Be 'A Dev'
    }

    It 'orders the layers foundational-first' {
        $subjects = @(& git -C $script:repo log --reverse --format='%s')
        $subjects | Should -Be @('Add core', 'Add core tests', 'Add docs')
    }

    It 'backdates every commit inside the span' {
        $dates = @(& git -C $script:repo log --format='%aI' | ForEach-Object { [datetime]::Parse($_) })
        foreach ($d in $dates) {
            $d | Should -BeGreaterOrEqual ([datetime]'2024-01-01')
            $d | Should -BeLessOrEqual ([datetime]'2024-03-02')
        }
    }

    It 'carries the working-tree files' {
        $tracked = @(& git -C $script:repo ls-files)
        $tracked | Should -Contain 'core/a.txt'
        $tracked | Should -Contain 'core/tests/t.txt'
        $tracked | Should -Contain 'docs/readme.md'
    }

    It 'leaves no trace of the old token in the rebuilt history' {
        (Test-GitHistoryClean -Token 'old-secret' -Ref '--all' -RepositoryPath $script:repo).Clean | Should -BeTrue
    }
}

Describe 'New-SyntheticHistory dry run' -Tag 'L1', 'logic' {
    It 'returns a plan without touching git' {
        Mock -ModuleName Catzc.Tooling.Github Assert-Command {}
        Mock -ModuleName Catzc.Tooling.Github Assert-PathExist {}
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { throw 'should not run' }
        $layers = @(@{ Message = 'a'; Include = @('.'); Exclude = @() }, @{ Message = 'b'; Include = @('.'); Exclude = @() })
        $result = New-SyntheticHistory -Layer $layers -RepositoryPath 'TestDrive:/' -AuthorName 'X' -AuthorEmail 'x@y.z' -DryRun
        $result.DryRun | Should -BeTrue
        $result.LayerCount | Should -Be 2
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0
    }
}
