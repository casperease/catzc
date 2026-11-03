Describe 'Assert-GitWorkTree' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:root) | Out-Null
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Repository
    }

    It 'is silent when the root holds a .git folder' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root '.git')) | Out-Null
        { Assert-GitWorkTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'is silent when the root holds a .git pointer file' {
        Set-Content -LiteralPath (Join-Path $script:root '.git') -Value 'gitdir: ../gadget/.git/worktrees/widget'
        { Assert-GitWorkTree -Command 'Format-Widget' } | Should -Not -Throw
    }

    It 'throws naming the given command and the root when the root has no .git' {
        { Assert-GitWorkTree -Command 'Format-Widget' } |
            Should -Throw "*Format-Widget works on a git work tree*$([WildcardPattern]::Escape($script:root))*has none*"
    }

    It 'names the calling command when none is given' {
        function Invoke-WidgetCaller {
            Assert-GitWorkTree
        }
        { Invoke-WidgetCaller } | Should -Throw '*Invoke-WidgetCaller works on a git work tree*'
    }
}
