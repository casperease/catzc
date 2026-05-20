Describe 'Test-GitHistoryClean' -Tag 'L2', 'logic' {
    BeforeAll {
        # A throwaway git repo whose history plants the token on all three surfaces:
        # a blob (file content), a path (file name), and a commit message.
        $script:repo = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-ghtest-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        New-Item -ItemType Directory -Path $script:repo -Force | Out-Null
        $repo = $script:repo

        & git -C $repo init -b main *> $null
        & git -C $repo config user.email 'test@example.com' *> $null
        & git -C $repo config user.name 'Test' *> $null
        & git -C $repo config commit.gpgsign false *> $null

        # Commit 1 — clean.
        Set-Content -Path (Join-Path $repo 'readme.txt') -Value 'hello world'
        & git -C $repo add -A *> $null
        & git -C $repo commit -m 'initial clean commit' *> $null

        # Commit 2 — token in a blob AND a commit message.
        Set-Content -Path (Join-Path $repo 'config.txt') -Value 'connection=SEKRET-TOKEN-value'
        & git -C $repo add -A *> $null
        & git -C $repo commit -m 'wire up SEKRET-TOKEN' *> $null

        # Commit 3 — token in a file path.
        Set-Content -Path (Join-Path $repo 'sekret-token-notes.md') -Value 'notes'
        & git -C $repo add -A *> $null
        & git -C $repo commit -m 'add notes' *> $null

        # Commit 4 — remove the token from the working tree (but it survives in history).
        Remove-Item (Join-Path $repo 'config.txt'), (Join-Path $repo 'sekret-token-notes.md')
        Set-Content -Path (Join-Path $repo 'config.txt') -Value 'connection=clean'
        & git -C $repo add -A *> $null
        & git -C $repo commit -m 'scrub working tree' *> $null
    }

    AfterAll {
        if ($script:repo -and (Test-Path $script:repo)) {
            Remove-Item -Recurse -Force $script:repo -ErrorAction SilentlyContinue
        }
    }

    It 'finds the token on all three surfaces across history' {
        $result = Test-GitHistoryClean -Token 'sekret-token' -RepositoryPath $script:repo
        $result.Clean | Should -BeFalse
        $result.Blobs | Should -Not -BeNullOrEmpty
        $result.Paths | Should -Contain 'sekret-token-notes.md'
        ($result.Messages -join "`n") | Should -Match 'SEKRET-TOKEN'
    }

    It 'matches case-insensitively as a literal substring' {
        (Test-GitHistoryClean -Token 'SEKRET-TOKEN' -RepositoryPath $script:repo).Clean | Should -BeFalse
    }

    It 'reports clean for a token that never appears' {
        $result = Test-GitHistoryClean -Token 'nonexistent-marker' -RepositoryPath $script:repo
        $result.Clean | Should -BeTrue
        $result.Blobs | Should -BeNullOrEmpty
        $result.Paths | Should -BeNullOrEmpty
        $result.Messages | Should -BeNullOrEmpty
    }

    It 'reports clean when the token only lives under an excluded path' {
        $vendor = Join-Path $script:repo 'automation/.vendor'
        New-Item -ItemType Directory -Path $vendor -Force | Out-Null
        Set-Content -Path (Join-Path $vendor 'thirdparty.txt') -Value 'has excluded-marker inside'
        & git -C $script:repo add -A *> $null
        & git -C $script:repo commit -m 'vendor drop' *> $null
        try {
            (Test-GitHistoryClean -Token 'excluded-marker' -RepositoryPath $script:repo).Clean | Should -BeTrue
        }
        finally {
            # Leave history as the other tests expect it — reset the vendor commit away.
            & git -C $script:repo reset --hard HEAD~1 *> $null
        }
    }

    It 'scans only the given ref, not unrelated branches' {
        # HEAD~3 is the initial clean commit — nothing planted yet.
        (Test-GitHistoryClean -Token 'sekret-token' -Ref 'HEAD~3' -RepositoryPath $script:repo).Clean | Should -BeTrue
    }
}
