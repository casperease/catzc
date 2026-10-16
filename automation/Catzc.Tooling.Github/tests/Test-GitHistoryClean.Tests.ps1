<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Tooling.Github
    relatives:
      page: docs/references/automation/catzc-tooling-github/tests/Test-GitHistoryClean.Tests.ps1.md
      source: automation/Catzc.Tooling.Github/Test-GitHistoryClean.ps1
---
#>

Describe 'Test-GitHistoryClean' -Tag 'L2', 'logic' {
    BeforeAll {
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

    It 'names each content hit by its blob, a path it lives under, and the line' {
        $blob = (& git -C $script:repo rev-parse 'HEAD~2:config.txt').Trim()
        (Test-GitHistoryClean -Token 'sekret-token' -RepositoryPath $script:repo).Blobs | Should -Be @("${blob}:config.txt:connection=SEKRET-TOKEN-value")
    }

    It 'sweeps every ref with --all' {
        & git -C $script:repo branch gadget 'HEAD~3' *> $null
        Set-Content -Path (Join-Path $script:repo 'widget.txt') -Value 'gizmo-marker'
        & git -C $script:repo add -A *> $null
        & git -C $script:repo commit -m 'widget on main' *> $null
        & git -C $script:repo checkout -q gadget *> $null
        try {
            (Test-GitHistoryClean -Token 'gizmo-marker' -RepositoryPath $script:repo).Clean | Should -BeTrue
            (Test-GitHistoryClean -Token 'gizmo-marker' -Ref '--all' -RepositoryPath $script:repo).Clean | Should -BeFalse
        }
        finally {
            & git -C $script:repo checkout -q main *> $null
            & git -C $script:repo reset --hard HEAD~1 *> $null
            & git -C $script:repo branch -D gadget *> $null
        }
    }

    It 'skips a binary file, as git grep -I does' {
        [System.IO.File]::WriteAllBytes((Join-Path $script:repo 'gadget.bin'), [byte[]] (@(0, 1, 2) + [System.Text.Encoding]::ASCII.GetBytes('binary-marker')))
        & git -C $script:repo add -A *> $null
        & git -C $script:repo commit -m 'binary drop' *> $null
        try {
            (Test-GitHistoryClean -Token 'binary-marker' -RepositoryPath $script:repo).Clean | Should -BeTrue
        }
        finally {
            & git -C $script:repo reset --hard HEAD~1 *> $null
        }
    }

    It 'throws for a ref that does not resolve' {
        { Test-GitHistoryClean -Token 'sekret-token' -Ref 'no-such-widget' -RepositoryPath $script:repo } | Should -Throw "*Cannot resolve ref 'no-such-widget'*"
    }
}
