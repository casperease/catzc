<#
---
catzc:
  immutable:
    with_body_sha: "8148d532a698"
  edges:
    code: pwsh/Catzc.Base.Git/Sync-Topic.ps1
    cites:
      - ADR-FLOW-GIT-SYNCBYREBASE
---
#>

Describe 'Sync-Topic' -Tag 'L0', 'logic', 'ADR-FLOW-GIT-SYNCBYREBASE' {
    BeforeAll {
        $script:config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        $script:onto = 'a' * 40
        function Set-Git {
            param([string] $Branch = 'widget', [string] $Status = '', [int] $RebaseExit = 0)
            $script:branch = $Branch
            $script:status = $Status
            $script:rebaseExit = $RebaseExit
            Mock Get-SyncPoint -ModuleName Catzc.Base.Git { [pscustomobject]@{ Commit = $script:onto; Source = 'fallback'; Branch = 'main' } }
            Mock Invoke-Executable -ModuleName Catzc.Base.Git {
                switch -Wildcard ($Command) {
                    'git rev-parse*' { [pscustomobject]@{ Output = $script:branch; ExitCode = 0 } }
                    'git status*' { [pscustomobject]@{ Output = $script:status; ExitCode = 0 } }
                    'git rebase*' { [pscustomobject]@{ Output = ''; ExitCode = $script:rebaseExit } }
                    'git diff*' { [pscustomobject]@{ Output = "widget.ps1`ngadget.yml"; ExitCode = 0 } }
                    default { [pscustomobject]@{ Output = ''; ExitCode = 0 } }
                }
            }
        }
    }

    BeforeEach {
        Mock Assert-Command -ModuleName Catzc.Base.Git { }
        Mock Write-Message -ModuleName Catzc.Base.Git { }
    }

    It 'fetches, then rebases the topic onto the resolved sync point' {
        Set-Git
        $result = Sync-Topic -Config $script:config
        $result.Onto | Should -BeExactly $script:onto
        $result.Source | Should -BeExactly 'fallback'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git fetch origin' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq "git rebase $script:onto" }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git merge*' }
    }

    It 'stops on a conflict with the files and the continue and abort commands, and never aborts on its own' {
        Set-Git -RebaseExit 1
        { Sync-Topic -Config $script:config } | Should -Throw "*conflicts in: widget.ps1, gadget.yml*git rebase --continue*git rebase --abort*"
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git rebase --abort*' -or $Command -like 'git rebase --skip*' }
    }

    It 'refuses <case>, and fetches nothing' -ForEach @(
        @{ case = 'a dirty tree'; Branch = 'widget'; Status = ' M widget.ps1'; expect = '*Run Save-Topic first*' }
        @{ case = 'a detached HEAD'; Branch = 'HEAD'; Status = ''; expect = '*needs a named branch*' }
        @{ case = 'a main branch'; Branch = 'master'; Status = ''; expect = "*'master' is a main branch*" }
    ) {
        Set-Git -Branch $Branch -Status $Status
        { Sync-Topic -Config $script:config } | Should -Throw $expect
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git fetch*' }
    }
}
