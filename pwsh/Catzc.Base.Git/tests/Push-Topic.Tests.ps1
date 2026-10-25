Describe 'Push-Topic' -Tag 'L0', 'logic', 'FDR-GIT-SQUASHREBASESQUASH' {
    BeforeAll {
        $script:config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $script:head = 'c' * 40
        $script:base = 'b' * 40
        $script:commit = 'd' * 40
        function Set-Git {
            param([string] $Branch = 'widget', [bool] $MainViaPr = $true, [string] $Ahead = '1', [string] $Before = '3', [int] $PushExit = 0, [int] $RebaseExit = 0)
            $script:calls = [System.Collections.Generic.List[string]]::new()
            $script:git = @{ Branch = $Branch; MainViaPr = $MainViaPr; Ahead = $Ahead; Before = $Before; PushExit = $PushExit; RebaseExit = $RebaseExit }
            Mock Save-Topic -ModuleName Catzc.Base.Git { $script:calls.Add('Save-Topic'); [pscustomobject]@{ Branch = $script:git.Branch; Saved = $true; Message = $Message } }
            Mock Test-GitWorkspace -ModuleName Catzc.Base.Git { $script:git.MainViaPr }
            Mock Invoke-Executable -ModuleName Catzc.Base.Git {
                $script:calls.Add($Command)
                $result = switch -Wildcard ($Command) {
                    'git rev-parse --verify --quiet origin/main' {
                        @('', 0)
                    }
                    'git rev-parse origin/main' {
                        @($script:head, 0)
                    }
                    'git rev-parse HEAD' {
                        @($script:commit, 0)
                    }
                    'git merge-base*' {
                        @($script:base, 0)
                    }
                    "git rev-list --count $script:base..HEAD" {
                        @($script:git.Before, 0)
                    }
                    "git rev-list --count $script:head..HEAD" {
                        @($script:git.Ahead, 0)
                    }
                    "git rev-list --count HEAD..$script:head" {
                        @('0', 0)
                    }
                    'git rebase*' {
                        @('', $script:git.RebaseExit)
                    }
                    'git diff*' {
                        @('widget.ps1', 0)
                    }
                    'git push*' {
                        @('', $script:git.PushExit)
                    }
                    default {
                        @('', 0)
                    }
                }
                [pscustomobject]@{ Output = $result[0]; ExitCode = $result[1] }
            }
        }
    }

    BeforeEach {
        Mock Assert-Command -ModuleName Catzc.Base.Git { }
        Mock Write-Message -ModuleName Catzc.Base.Git { }
    }

    It 'saves, squashes, rebases onto the server HEAD, squashes again, and pushes the topic with a lease in main-via-pr' {
        Set-Git
        $result = Push-Topic -Message 'spin' -Config $script:config
        $result.Target | Should -BeExactly 'widget'
        $result.Commit | Should -BeExactly $script:commit
        $steps = @($script:calls | Where-Object { $_ -eq 'Save-Topic' -or $_ -like 'git fetch*' -or $_ -like 'git reset*' -or $_ -like 'git commit*' -or $_ -like 'git rebase*' -or $_ -like 'git push*' })
        $steps | Should -Be @(
            'Save-Topic'
            'git fetch origin'
            "git reset --soft $script:base"
            'git commit -m "spin"'
            "git rebase $script:head"
            "git reset --soft $script:head"
            'git commit -m "spin"'
            'git push --force-with-lease origin widget:widget'
        )
    }

    It 'fast-pushes the one commit to main in main-direct, never with force' -Tag 'FDR-GIT-ONESQUASHEDCOMMIT' {
        Set-Git -MainViaPr $false
        (Push-Topic -Config $script:config).Target | Should -BeExactly 'main'
        $script:calls | Should -Contain 'git push origin HEAD:main'
        @($script:calls | Where-Object { $_ -like '*force*' }) | Should -HaveCount 0
    }

    It 'refuses to force a main branch in main-via-pr' -Tag 'FDR-GIT-TOPICHISTORYISTHEAUTHORS' {
        Set-Git -Branch 'main'
        { Push-Topic -Config $script:config } | Should -Throw "*main-via-pr and 'main' is a main branch*"
        @($script:calls | Where-Object { $_ -like 'git push*' }) | Should -HaveCount 0
    }

    It 'stops before the push unless the topic is exactly one commit ahead' {
        Set-Git -Ahead '2'
        { Push-Topic -Config $script:config } | Should -Throw '*2 ahead and 0 behind*expected 1 ahead and 0 behind*'
        @($script:calls | Where-Object { $_ -like 'git push*' }) | Should -HaveCount 0
    }

    It 'stops on a rejected push and keeps the commit' {
        Set-Git -MainViaPr $false -PushExit 1
        { Push-Topic -Config $script:config } | Should -Throw "*rejected*commit $script:commit is kept*"
        @($script:calls | Where-Object { $_ -like 'git reset --hard*' }) | Should -HaveCount 0
    }

    It 'stops on a rebase conflict with the continue and abort commands' {
        Set-Git -RebaseExit 1
        { Push-Topic -Config $script:config } | Should -Throw '*conflicts in: widget.ps1*git rebase --continue*git rebase --abort*'
    }

    It 'pushes nothing when the topic holds no change beyond the server' {
        Set-Git -Before '0'
        Push-Topic -Config $script:config | Should -BeNullOrEmpty
        @($script:calls | Where-Object { $_ -like 'git push*' -or $_ -like 'git reset*' }) | Should -HaveCount 0
    }
}
