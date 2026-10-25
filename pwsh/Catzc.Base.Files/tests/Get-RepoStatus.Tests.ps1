# Rests on [ADR-REPO-FILEMETA-FILEISNODE](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode).
Describe 'Get-RepoStatus' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:tracked = @('widget/a.md')
        $script:porcelain = ''
        $script:branch = 'main'
        $script:upstream = 'origin/main'
        $script:pendingCommits = ''
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { 'C:\widget-repo' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Files { $script:tracked }
        Mock Invoke-Executable -ModuleName Catzc.Base.Files {
            $output = switch -Wildcard ($Command) {
                'git status*' {
                    $script:porcelain
                }
                'git branch*' {
                    $script:branch
                }
                'git for-each-ref*' {
                    $script:upstream
                }
                'git log*' {
                    $script:pendingCommits
                }
            }
            [pscustomobject]@{ ExitCode = 0; Output = $output }
        }
    }

    It 'is unset for a file git does not track' {
        Get-RepoStatus 'gadget/new.md' | Should -Be 'unset'
    }

    It 'is edited when the working tree differs from the index' {
        $script:porcelain = " M widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'edited'
        $script:porcelain = "MM widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'edited'
    }

    It 'is staged when only the index differs from HEAD' {
        $script:porcelain = "M  widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'staged'
    }

    It 'is ready when unchanged on a branch with no upstream' {
        $script:upstream = ''
        Get-RepoStatus 'widget/a.md' | Should -Be 'ready'
    }

    It 'is committed when a commit touching the file is not on the upstream' {
        $script:pendingCommits = 'abc123'
        Get-RepoStatus 'widget/a.md' | Should -Be 'committed'
    }

    It 'is pushed when every commit touching the file is on the upstream' {
        Get-RepoStatus 'widget/a.md' | Should -Be 'pushed'
    }

    It 'accepts a backslash path' {
        Get-RepoStatus 'widget\a.md' | Should -Be 'pushed'
    }
}

Describe 'Get-RepoStatus against real git' -Tag 'L2', 'logic' {
    # One real repository with a local bare remote in TestDrive: every state from git's own answers.
    BeforeAll {
        $script:remote = Join-Path $TestDrive 'widget-remote.git'
        $script:repo = Join-Path $TestDrive 'gadget-repo'
        [void][System.IO.Directory]::CreateDirectory($script:remote)
        [void][System.IO.Directory]::CreateDirectory($script:repo)
        $git = { param([string] $Arguments, [string] $In) Invoke-Executable "git $Arguments" -WorkingDirectory $In -Silent }
        & $git 'init -q --bare' $script:remote
        & $git 'init -q' $script:repo
        & $git 'config user.email widget@example.invalid' $script:repo
        & $git 'config user.name Widget' $script:repo
        foreach ($name in 'pushed.txt', 'edited.txt', 'staged.txt') {
            [System.IO.File]::WriteAllText((Join-Path $script:repo $name), "$name`n")
        }
        & $git 'add -A' $script:repo
        & $git 'commit -q -m fixture' $script:repo
        & $git "remote add origin `"$($script:remote)`"" $script:repo
        & $git 'push -q -u origin HEAD' $script:repo
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'committed.txt'), "committed`n")
        & $git 'add committed.txt' $script:repo
        & $git 'commit -q -m local' $script:repo
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'edited.txt'), "changed`n")
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'staged.txt'), "changed`n")
        & $git 'add staged.txt' $script:repo
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'new.txt'), "new`n")
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:repo }
    }

    It 'tells each state from git itself' {
        Get-RepoStatus 'pushed.txt' | Should -Be 'pushed'
        Get-RepoStatus 'committed.txt' | Should -Be 'committed'
        Get-RepoStatus 'edited.txt' | Should -Be 'edited'
        Get-RepoStatus 'staged.txt' | Should -Be 'staged'
        Get-RepoStatus 'new.txt' | Should -Be 'unset'
    }
}
