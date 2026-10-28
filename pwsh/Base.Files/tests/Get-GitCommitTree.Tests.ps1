Describe 'Get-GitCommitTree' -Tag 'L0', 'logic' {
    BeforeAll {
        # A hand-built git directory: HEAD on a branch whose ref names the widget commit.
        $script:root = Join-Path $TestDrive 'repo'
        $script:widgetCommit = 'a' * 40
        $script:gadgetCommit = 'b' * 40
        $heads = Join-Path $script:root '.git/refs/heads'
        New-Item -ItemType Directory -Path $heads -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $script:root '.git/HEAD') -Value 'ref: refs/heads/main' -NoNewline
        Set-Content -LiteralPath (Join-Path $heads 'main') -Value $script:widgetCommit -NoNewline
        $script:listing = @{
            $script:widgetCommit = "100644 blob $('1' * 40)`tdocs/widget.md`0100755 blob $('2' * 40)`twidgets/Get-Widget.ps1`0" +
            "160000 commit $('3' * 40)`tvendor/gadget`0040000 tree $('4' * 40)`twidgets"
            $script:gadgetCommit = "100644 blob $('5' * 40)`tdocs/gadget.md"
        }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:root }
    }

    BeforeEach {
        InModuleScope Catzc.Base.Files { $script:gitCommitTreeCache = $null }
        Mock Invoke-Executable -ModuleName Catzc.Base.Files {
            $commit = $Command.Split(' ')[-1]
            [Catzc.Base.Execution.CliResult]::new($script:listing[$commit], '', 0)
        }
    }

    It 'lists the blobs of HEAD''s commit, path to blob id, in git''s order, and no submodule or tree' {
        $tree = Get-GitCommitTree
        @($tree.Keys) | Should -Be @('docs/widget.md', 'widgets/Get-Widget.ps1')
        $tree['widgets/Get-Widget.ps1'] | Should -Be ('2' * 40)
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq "git ls-tree -r -z --full-tree $script:widgetCommit" -and $WorkingDirectory -eq $script:root
        }
    }

    It 'reads the revision it is given' {
        @((Get-GitCommitTree -Revision $script:gadgetCommit).Keys) | Should -Be @('docs/gadget.md')
    }

    It 'launches git once per commit and follows HEAD when it moves' {
        $null = Get-GitCommitTree
        $null = Get-GitCommitTree 'HEAD'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly
        Set-Content -LiteralPath (Join-Path $script:root '.git/refs/heads/main') -Value $script:gadgetCommit -NoNewline
        try {
            @((Get-GitCommitTree).Keys) | Should -Be @('docs/gadget.md')
        }
        finally {
            Set-Content -LiteralPath (Join-Path $script:root '.git/refs/heads/main') -Value $script:widgetCommit -NoNewline
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 2 -Exactly
    }

    It 'refuses a ref that names no commit' {
        { Get-GitCommitTree -Revision 'gizmo' } | Should -Throw "*'gizmo' does not name a ref*"
    }

    It 'refuses an empty revision' {
        { Get-GitCommitTree -Revision '' } | Should -Throw
    }
}

Describe 'Get-GitCommitTree — the real repository' -Tag 'L2', 'integrity', 'source-only' {
    It 'lists the paths git ls-tree lists for HEAD' {
        $names = Invoke-Executable 'git ls-tree -r --name-only -z HEAD' -PassThru -Silent
        @((Get-GitCommitTree).Keys) | Should -Be @("$($names.Output)" -split "`0" | Where-Object { $_ })
    }
}
