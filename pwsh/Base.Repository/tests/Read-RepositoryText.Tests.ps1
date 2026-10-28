Describe 'Read-RepositoryText' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:outside = Join-Path $TestDrive 'outside.yml'
        New-Item -ItemType Directory -Path (Join-Path $script:root 'widgets') -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/gadget.yml') -Value 'working: tree' -NoNewline
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/local.yml') -Value 'only: here' -NoNewline
        Set-Content -LiteralPath $script:outside -Value 'outside: disk' -NoNewline
        $script:commit = @{
            Name = 'c' * 40
            Path = [string[]] @('widgets/gadget.yml', 'widgets/unread.yml')
            Text = @{ 'widgets/gadget.yml' = 'committed: text' }
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { Join-Path $TestDrive 'repo' }
    }

    It 'reads the working tree outside a source, by a relative or an absolute path, and nothing for an absent file' {
        Read-RepositoryText 'widgets/gadget.yml' | Should -BeExactly 'working: tree'
        Read-RepositoryText (Join-Path $script:root 'widgets/gadget.yml') | Should -BeExactly 'working: tree'
        Read-RepositoryText 'widgets/absent.yml' | Should -BeNullOrEmpty
    }

    It 'reads the source''s text inside a source, whatever the working tree holds' {
        $text = Use-RepositoryTextSource @script:commit -ScriptBlock { Read-RepositoryText (Join-Path $script:root 'widgets/gadget.yml') }
        $text | Should -BeExactly 'committed: text'
    }

    It 'reads a working-tree-only file as absent inside a source' {
        Use-RepositoryTextSource @script:commit -ScriptBlock { Read-RepositoryText 'widgets/local.yml' } | Should -BeNullOrEmpty
    }

    It 'throws for a path the source lists but did not load, rather than guess' {
        { Use-RepositoryTextSource @script:commit -ScriptBlock { Read-RepositoryText 'widgets/unread.yml' } } |
            Should -Throw "*'widgets/unread.yml' is in source*its text was not loaded*"
    }

    It 'reads a file outside the repository from disk inside a source too' {
        Use-RepositoryTextSource @script:commit -ScriptBlock { Read-RepositoryText $script:outside } | Should -BeExactly 'outside: disk'
    }
}
