<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-git/tests/Push-Topic.Flow.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'The git topic flow over a scratch server' -Tag 'L2', 'logic', 'FDR-GIT-USERRUNSGIT' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
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
        if ($script:skip) {
            return
        }
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
        Add-Commit -Path $script:seed -File 'widget.txt' -Text 'one' -Push
        $script:topic = New-Clone 'topic' -Branch 'spin-widget'
    }

    It 'resolves the current server HEAD as the sync point and announces the fallback' -Tag 'FDR-GIT-FALLBACKISANNOUNCED' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $point = Get-SyncPoint -Config $script:config -RepositoryRoot $script:topic
        $point.Source | Should -BeExactly 'fallback'
        $point.Commit | Should -BeExactly (Invoke-Scratch $script:server @('rev-parse', 'main'))
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Warning -and $Message -like '*marks no BVT-verified head*' }
    }

    It 'rebases the topic onto new server work' -Tag 'FDR-GIT-SYNCBYREBASE' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Add-Commit -Path $script:topic -File 'gadget.txt' -Text 'topic'
        Add-Commit -Path $script:seed -File 'sprocket.txt' -Text 'server' -Push
        $result = Sync-Topic -Config $script:config -RepositoryRoot $script:topic -WarningAction SilentlyContinue
        $result.Onto | Should -BeExactly (Invoke-Scratch $script:server @('rev-parse', 'main'))
        Invoke-Scratch $script:topic @('rev-parse', 'HEAD~1') | Should -BeExactly $result.Onto
        Join-Path $script:topic 'sprocket.txt' | Should -Exist
        Invoke-Scratch $script:topic @('rev-list', '--merges', '--count', 'HEAD') | Should -Be '0'
    }

    It 'stops on a conflict and leaves the rebase to the user' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Add-Commit -Path $script:topic -File 'widget.txt' -Text 'topic edit'
        Add-Commit -Path $script:seed -File 'widget.txt' -Text 'server edit' -Push
        { Sync-Topic -Config $script:config -RepositoryRoot $script:topic -WarningAction SilentlyContinue } |
            Should -Throw '*conflicts in: widget.txt*git rebase --abort*'
        Test-Path -LiteralPath (Join-Path $script:topic '.git/rebase-merge') |
            Should -BeTrue -Because 'the rebase waits for the user'
        Invoke-Scratch $script:topic @('rebase', '--abort') | Out-Null
    }

    It 'lands a three-commit topic as one commit on main in main-direct' -Tag 'FDR-GIT-ONESQUASHEDCOMMIT' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $before = Invoke-Scratch $script:server @('rev-parse', 'main')
        Add-Commit -Path $script:topic -File 'gadget.txt' -Text 'one'
        Add-Commit -Path $script:topic -File 'sprocket.txt' -Text 'two'
        [System.IO.File]::WriteAllText((Join-Path $script:topic 'cog.txt'), "three`n")
        $result = Push-Topic -Message 'spin the widget' -Config $script:config -RepositoryRoot $script:topic
        $result.Target | Should -BeExactly 'main'
        Invoke-Scratch $script:server @('rev-parse', 'main') | Should -BeExactly $result.Commit
        Invoke-Scratch $script:server @('rev-parse', 'main~1') | Should -BeExactly $before
        Invoke-Scratch $script:server @('log', '-1', '--format=%s', 'main') | Should -BeExactly 'spin the widget'
        Invoke-Scratch $script:server @('ls-tree', '--name-only', 'main') |
            Should -BeLike '*cog.txt*gadget.txt*sprocket.txt*'
    }

    It 'stops on a rejected push and keeps the commit' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        [System.IO.File]::WriteAllText((Join-Path $script:server 'hooks/pre-receive'), "#!/bin/sh`nexit 1`n")
        Add-Commit -Path $script:topic -File 'gadget.txt' -Text 'one'
        { Push-Topic -Config $script:config -RepositoryRoot $script:topic } | Should -Throw '*rejected*is kept*'
        Invoke-Scratch $script:topic @('rev-list', '--count', 'origin/main..HEAD') | Should -Be '1'
    }

    It 'refuses main in main-via-pr' -Tag 'FDR-GIT-TOPICHISTORYISTHEAUTHORS' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Mock Test-GitWorkspace -ModuleName Catzc.Base.Git { $true }
        Invoke-Scratch $script:topic @('checkout', '--quiet', 'main') | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:topic 'gadget.txt'), "one`n")
        { Push-Topic -Config $script:config -RepositoryRoot $script:topic } | Should -Throw "*main-via-pr and 'main'*"
        Invoke-Scratch $script:server @('rev-list', '--count', 'main') | Should -Be '1'
    }
}
