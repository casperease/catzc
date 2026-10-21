<#
---
catzc:
  immutable:
    with_body_sha: "7f4a0385cc3a"
  edges:
    code: pwsh/Catzc.Base.Git/types/GitFlowConfig.cs
    cites:
      - ADR-FLOW-GIT-USERRUNSGIT
      - ADR-FLOW-GIT-SYNCPOINT
      - PDR-CONFIG-DEFAULTDECLAREDONCE
---
#>

Describe 'GitFlowConfig' -Tag 'L0', 'logic', 'PDR-CONFIG-DEFAULTDECLAREDONCE' {
    It 'takes the declared defaults for every omitted key' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $config.remote | Should -BeExactly 'origin'
        $config.main_branches | Should -Be @('main', 'master')
        $config.bvt_mark_kind | Should -BeExactly 'none'
        $config.bvt_mark_ref | Should -BeNullOrEmpty
        $config.user_commands | Should -Be @('Sync-Topic', 'Save-Topic', 'Push-Topic')
        $config.IsMain('master') | Should -BeTrue
        $config.IsMain('widget') | Should -BeFalse
        $config.IsMain($null) | Should -BeFalse
    }

    It 'takes each stated value, a ref mark included' -Tag 'ADR-FLOW-GIT-SYNCPOINT' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{
                remote        = 'upstream'
                main_branches = @('trunk')
                bvt_mark      = @{ ref = 'refs/tags/widget-verified' }
                user_commands = @('Sync-Widget')
            })
        $config.remote | Should -BeExactly 'upstream'
        $config.main_branches | Should -Be @('trunk')
        $config.bvt_mark_kind | Should -BeExactly 'ref'
        $config.bvt_mark_ref | Should -BeExactly 'refs/tags/widget-verified'
        $config.user_commands | Should -Be @('Sync-Widget')
        [Catzc.Base.Git.GitFlowConfig]::new(@{ bvt_mark = 'none' }).bvt_mark_kind | Should -BeExactly 'none'
    }

    It 'finds a user command a command line invokes, and none in a path or name that holds it' -Tag 'ADR-FLOW-GIT-USERRUNSGIT' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $config.UserCommandIn('pwsh -NoProfile -Command ". ./importer.ps1; Push-Topic -Message x"') | Should -BeExactly 'Push-Topic'
        $config.UserCommandIn('pwsh -c "sync-topic"') | Should -BeExactly 'Sync-Topic'
        $config.UserCommandIn('pwsh -c "Get-SyncPoint"') | Should -BeNullOrEmpty
        $config.UserCommandIn('timeout 330 pwsh -File out/run.ps1 -Path pwsh/Catzc.Base.Git/tests/Save-Topic.Tests.ps1') | Should -BeNullOrEmpty
        $config.UserCommandIn('cat pwsh/Catzc.Base.Git/Push-Topic.ps1') | Should -BeNullOrEmpty
        $config.UserCommandIn('') | Should -BeNullOrEmpty
    }

    It 'finds a user command in command position: bare, after a separator, through cats, or in a pwsh -Command script' -Tag 'ADR-FLOW-GIT-USERRUNSGIT' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $config.UserCommandIn('Push-Topic -Message x') | Should -BeExactly 'Push-Topic'
        $config.UserCommandIn('cd out && Save-Topic') | Should -BeExactly 'Save-Topic'
        $config.UserCommandIn('echo x | Sync-Topic') | Should -BeExactly 'Sync-Topic'
        $config.UserCommandIn('cats push-topic --message x') | Should -BeExactly 'Push-Topic'
        $config.UserCommandIn('timeout 300 pwsh -c "& Push-Topic"') | Should -BeExactly 'Push-Topic'
    }

    It 'finds none in a quoted mention, a printf argument or a heredoc body' -Tag 'ADR-FLOW-GIT-USERRUNSGIT' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $config.UserCommandIn('echo "the user runs Push-Topic"') | Should -BeNullOrEmpty
        $config.UserCommandIn("printf '%s\n' Push-Topic >> out/log.md") | Should -BeNullOrEmpty
        $config.UserCommandIn("cat > out/note.md <<'EOF'`nPush-Topic -Message x`nEOF`necho done") | Should -BeNullOrEmpty
        $config.UserCommandIn('pwsh -c "Write-Output ''run Save-Topic next''"') | Should -BeNullOrEmpty
    }

    It 'finds the shipped config under the modules folder' -Tag 'L1' {
        ([Catzc.Base.Git.GitFlowConfig]::FindConfig((Get-RepositoryRoot))).Replace('\', '/') | Should -BeLike '*/Catzc.Base.Git/configs/git.yml'
    }

    It 'rejects <case>' -ForEach @(
        @{ case = 'an unknown key'; raw = @{ gadget = 1 }; expect = "*unknown top-level key 'gadget'*" }
        @{ case = 'an unknown mark kind'; raw = @{ bvt_mark = 'tag' }; expect = "*unknown mark kind 'tag'*" }
        @{ case = 'an unknown mark key'; raw = @{ bvt_mark = @{ note = 'widget' } }; expect = "*unknown mark kind 'note'*" }
        @{ case = 'a ref mark without its ref'; raw = @{ bvt_mark = @{ ref = '' } }; expect = '*ref must name the ref*' }
        @{ case = 'an empty main branch list'; raw = @{ main_branches = @() }; expect = '*main_branches must be a non-empty list*' }
        @{ case = 'a remote with a space'; raw = @{ remote = 'wid get' }; expect = '*remote must be a remote name*' }
    ) {
        { [Catzc.Base.Git.GitFlowConfig]::new($raw) } | Should -Throw $expect
    }
}
