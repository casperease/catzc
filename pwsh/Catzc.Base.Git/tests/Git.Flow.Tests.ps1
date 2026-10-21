<#
---
catzc:
  immutable:
    with_body_sha: f0f81c35126c
  edges:
    cites:
      - ADR-FLOW-GIT-USERRUNSGIT
      - ADR-FLOW-GIT-FALLBACKISANNOUNCED
      - ADR-FLOW-GIT-SYNCBYREBASE
      - ADR-FLOW-GIT-ONESQUASHEDCOMMIT
      - ADR-FLOW-GIT-TOPICHISTORYISTHEAUTHORS
---
#>

Describe 'The git topic flow over a scratch server' -Tag 'L1', 'integration', 'ADR-FLOW-GIT-USERRUNSGIT' {
    BeforeAll {
        $script:config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        function Invoke-Scratch {
            param([string] $Path, [string[]] $Arguments)
            $output = & git -C $Path @Arguments 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "git $($Arguments -join ' ') failed in ${Path}: $output"
            }
            "$output".Trim()
        }
        function New-Clone {
            param([string] $Name, [string] $Branch)
            $path = Join-Path $script:scratch $Name
            & git clone --quiet $script:server $path 2>&1 | Out-Null
            Invoke-Scratch $path @('config', 'user.email', 'widget@example.com') | Out-Null
            Invoke-Scratch $path @('config', 'user.name', 'Widget') | Out-Null
            if ($Branch) {
                Invoke-Scratch $path @('checkout', '--quiet', '-b', $Branch) | Out-Null
            }
            $path
        }
        function Add-Commit {
            param([string] $Path, [string] $File, [string] $Text, [switch] $Push)
            [System.IO.File]::WriteAllText((Join-Path $Path $File), "$Text`n")
            Invoke-Scratch $Path @('add', '-A') | Out-Null
            Invoke-Scratch $Path @('commit', '--quiet', '-m', "add $File") | Out-Null
            if ($Push) {
                Invoke-Scratch $Path @('push', '--quiet', 'origin', 'HEAD:main') | Out-Null
            }
        }
    }

    BeforeEach {
        # Every flow command names its clone; a git call that fell back to the loaded repository would land here and fail.
        $script:nowhere = Join-Path $TestDrive 'not-a-repository'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Git { $script:nowhere }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Execution { $script:nowhere }
        Mock Write-Message -ModuleName Catzc.Base.Git { }
        Mock Test-GitWorkspace -ModuleName Catzc.Base.Git { $false }

        $script:scratch = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
        $script:server = Join-Path $script:scratch 'server.git'
        [void][System.IO.Directory]::CreateDirectory($script:scratch)
        & git init --quiet --bare --initial-branch=main $script:server 2>&1 | Out-Null
        $script:seed = New-Clone 'seed'
        Invoke-Scratch $script:seed @('checkout', '--quiet', '-b', 'main') | Out-Null
        Add-Commit $script:seed 'widget.txt' 'one' -Push
        $script:topic = New-Clone 'topic' -Branch 'spin-widget'
    }

    It 'resolves the current server HEAD as the sync point and announces the fallback' -Tag 'ADR-FLOW-GIT-FALLBACKISANNOUNCED' {
        $point = Get-SyncPoint -Config $script:config -RepositoryRoot $script:topic -WarningVariable warned -WarningAction SilentlyContinue
        $point.Source | Should -BeExactly 'fallback'
        $point.Commit | Should -BeExactly (Invoke-Scratch $script:server @('rev-parse', 'main'))
        "$warned" | Should -BeLike '*marks no BVT-verified head*'
    }

    It 'rebases the topic onto new server work' -Tag 'ADR-FLOW-GIT-SYNCBYREBASE' {
        Add-Commit $script:topic 'gadget.txt' 'topic'
        Add-Commit $script:seed 'sprocket.txt' 'server' -Push
        $result = Sync-Topic -Config $script:config -RepositoryRoot $script:topic -WarningAction SilentlyContinue
        $result.Onto | Should -BeExactly (Invoke-Scratch $script:server @('rev-parse', 'main'))
        Invoke-Scratch $script:topic @('rev-parse', 'HEAD~1') | Should -BeExactly $result.Onto
        Join-Path $script:topic 'sprocket.txt' | Should -Exist
        Invoke-Scratch $script:topic @('rev-list', '--merges', '--count', 'HEAD') | Should -Be '0'
    }

    It 'stops on a conflict and leaves the rebase to the user' {
        Add-Commit $script:topic 'widget.txt' 'topic edit'
        Add-Commit $script:seed 'widget.txt' 'server edit' -Push
        { Sync-Topic -Config $script:config -RepositoryRoot $script:topic -WarningAction SilentlyContinue } | Should -Throw '*conflicts in: widget.txt*git rebase --abort*'
        Test-Path -LiteralPath (Join-Path $script:topic '.git/rebase-merge') | Should -BeTrue -Because 'the rebase waits for the user'
        Invoke-Scratch $script:topic @('rebase', '--abort') | Out-Null
    }

    It 'lands a three-commit topic as one commit on main in main-direct' -Tag 'ADR-FLOW-GIT-ONESQUASHEDCOMMIT' {
        $before = Invoke-Scratch $script:server @('rev-parse', 'main')
        Add-Commit $script:topic 'gadget.txt' 'one'
        Add-Commit $script:topic 'sprocket.txt' 'two'
        [System.IO.File]::WriteAllText((Join-Path $script:topic 'cog.txt'), "three`n")
        $result = Push-Topic -Message 'spin the widget' -Config $script:config -RepositoryRoot $script:topic
        $result.Target | Should -BeExactly 'main'
        Invoke-Scratch $script:server @('rev-parse', 'main') | Should -BeExactly $result.Commit
        Invoke-Scratch $script:server @('rev-parse', 'main~1') | Should -BeExactly $before
        Invoke-Scratch $script:server @('log', '-1', '--format=%s', 'main') | Should -BeExactly 'spin the widget'
        Invoke-Scratch $script:server @('ls-tree', '--name-only', 'main') | Should -BeLike '*cog.txt*gadget.txt*sprocket.txt*'
    }

    It 'stops on a rejected push and keeps the commit' {
        [System.IO.File]::WriteAllText((Join-Path $script:server 'hooks/pre-receive'), "#!/bin/sh`nexit 1`n")
        Add-Commit $script:topic 'gadget.txt' 'one'
        { Push-Topic -Config $script:config -RepositoryRoot $script:topic } | Should -Throw '*rejected*is kept*'
        Invoke-Scratch $script:topic @('rev-list', '--count', 'origin/main..HEAD') | Should -Be '1'
    }

    It 'refuses main in main-via-pr' -Tag 'ADR-FLOW-GIT-TOPICHISTORYISTHEAUTHORS' {
        Mock Test-GitWorkspace -ModuleName Catzc.Base.Git { $true }
        Invoke-Scratch $script:topic @('checkout', '--quiet', 'main') | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:topic 'gadget.txt'), "one`n")
        { Push-Topic -Config $script:config -RepositoryRoot $script:topic } | Should -Throw "*main-via-pr and 'main'*"
        Invoke-Scratch $script:server @('rev-list', '--count', 'main') | Should -Be '1'
    }
}
