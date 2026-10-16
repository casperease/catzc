<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/tests/types/GitRefs.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Git
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'GitRefs' -Tag 'L0', 'logic' {
    BeforeAll {
        # A git directory written by hand: the reader only reads ref files, so no git is needed.
        function script:New-Id {
            param([int] $Number)
            '{0:x40}' -f $Number
        }

        function script:Set-GitFile {
            param([string] $Root, [string] $Path, [string] $Content)
            $full = Join-Path $Root $Path
            New-Item -ItemType Directory -Path (Split-Path $full) -Force | Out-Null
            [System.IO.File]::WriteAllText($full, $Content)
        }

        $script:checkout = Join-Path $TestDrive 'widget'
        $script:gitDir = Join-Path $checkout '.git'
        $main = New-Id 1
        $gadget = New-Id 2
        $tagObject = New-Id 3
        $tagCommit = New-Id 4
        $remote = New-Id 5
        $script:ids = @{ main = $main; gadget = $gadget; tagCommit = $tagCommit; remote = $remote }

        Set-GitFile $gitDir 'HEAD' "ref: refs/heads/main`n"
        Set-GitFile $gitDir 'refs/heads/main' "$main`n"
        Set-GitFile $gitDir 'refs/remotes/origin/HEAD' "ref: refs/remotes/origin/main`n"
        Set-GitFile $gitDir 'packed-refs' (@(
                '# pack-refs with: peeled fully-peeled sorted'
                "$gadget refs/heads/gadget"
                "$tagObject refs/tags/v1"
                "^$tagCommit"
                "$remote refs/remotes/origin/main"
            ) -join "`n")

        # A linked worktree: its .git is a pointer, its git directory names the shared one in commondir.
        $script:worktree = Join-Path $TestDrive 'gizmo'
        $worktreeGitDir = Join-Path $gitDir 'worktrees/gizmo'
        Set-GitFile $worktree '.git' "gitdir: ../widget/.git/worktrees/gizmo`n"
        Set-GitFile $worktreeGitDir 'HEAD' "$gadget`n"
        Set-GitFile $worktreeGitDir 'commondir' "../..`n"
    }

    It 'finds the git directory of a checkout, and of a linked worktree through its gitdir pointer' {
        [Catzc.Base.Git.GitRefs]::GitDirectory($checkout) | Should -Be ([System.IO.Path]::GetFullPath($gitDir))
        [Catzc.Base.Git.GitRefs]::GitDirectory($worktree) | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $gitDir 'worktrees/gizmo')))
    }

    It 'names the index file inside the git directory' {
        [Catzc.Base.Git.GitRefs]::IndexPath($gitDir) | Should -Be (Join-Path $gitDir 'index')
    }

    It 'resolves <name> to its commit' -ForEach @(
        @{ name = 'HEAD'; expected = 'main' }
        @{ name = 'main'; expected = 'main' }
        @{ name = 'refs/heads/main'; expected = 'main' }
        @{ name = 'gadget'; expected = 'gadget' }
        @{ name = 'v1'; expected = 'tagCommit' }
        @{ name = 'origin/main'; expected = 'remote' }
        @{ name = 'origin'; expected = 'remote' }
    ) {
        [Catzc.Base.Git.GitRefs]::ResolveCommit($gitDir, $name) | Should -Be $ids[$expected]
    }

    It 'passes a full object id through' {
        [Catzc.Base.Git.GitRefs]::ResolveCommit($gitDir, $ids.gadget.ToUpperInvariant()) | Should -Be $ids.gadget
    }

    It 'reads a linked worktree: its own HEAD, the shared refs' {
        $worktreeGitDir = [Catzc.Base.Git.GitRefs]::GitDirectory($worktree)
        [Catzc.Base.Git.GitRefs]::ResolveCommit($worktreeGitDir, 'HEAD') | Should -Be $ids.gadget
        [Catzc.Base.Git.GitRefs]::ResolveCommit($worktreeGitDir, 'main') | Should -Be $ids.main
        [Catzc.Base.Git.GitRefs]::CurrentBranch($worktreeGitDir) | Should -Be 'HEAD'
    }

    It 'names the current branch short' {
        [Catzc.Base.Git.GitRefs]::CurrentBranch($gitDir) | Should -Be 'main'
    }

    It 'throws for <problem>' -ForEach @(
        @{ problem = 'a name that matches no ref'; name = 'no-such-widget'; expected = "*'no-such-widget' does not name a ref*" }
        @{ problem = 'an empty name'; name = ' '; expected = '*must not be empty*' }
    ) {
        { [Catzc.Base.Git.GitRefs]::ResolveCommit($gitDir, $name) } | Should -Throw $expected
    }

    It 'throws for a folder that is not a checkout' {
        { [Catzc.Base.Git.GitRefs]::GitDirectory($TestDrive) } | Should -Throw '*is not a git checkout*'
    }

    It 'rejects a reftable ref store loudly' {
        $tableStore = Join-Path $TestDrive 'table-widget/.git'
        Set-GitFile $tableStore 'HEAD' "ref: refs/heads/.invalid`n"
        New-Item -ItemType Directory -Path (Join-Path $tableStore 'reftable') -Force | Out-Null
        { [Catzc.Base.Git.GitRefs]::ResolveCommit($tableStore, 'HEAD') } | Should -Throw '*reftable*'
    }

    It 'rejects a symbolic ref loop' {
        $loop = Join-Path $TestDrive 'loop-widget/.git'
        Set-GitFile $loop 'HEAD' "ref: refs/heads/a`n"
        Set-GitFile $loop 'refs/heads/a' "ref: refs/heads/b`n"
        Set-GitFile $loop 'refs/heads/b' "ref: refs/heads/a`n"
        { [Catzc.Base.Git.GitRefs]::ResolveCommit($loop, 'HEAD') } | Should -Throw '*too deep*'
    }
}

Describe 'GitRefs — parity with git rev-parse on this repository' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:root = Get-RepositoryRoot
        $script:gitDir = [Catzc.Base.Git.GitRefs]::GitDirectory($root)
    }

    It 'resolves HEAD to the commit git names' {
        [Catzc.Base.Git.GitRefs]::ResolveCommit($gitDir, 'HEAD') | Should -Be (& git -C $root rev-parse HEAD).Trim()
    }

    It 'names the branch git names' {
        [Catzc.Base.Git.GitRefs]::CurrentBranch($gitDir) | Should -Be (& git -C $root rev-parse --abbrev-ref HEAD).Trim()
    }

    It 'finds the index git names' {
        [Catzc.Base.Git.GitRefs]::IndexPath($gitDir) | Should -Be ([System.IO.Path]::GetFullPath((& git -C $root rev-parse --path-format=absolute --git-path index).Trim()))
    }
}
