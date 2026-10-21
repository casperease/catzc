<#
---
catzc:
  immutable:
    with_body_sha: "6984a3ebdc58"
  edges:
    code: pwsh/Catzc.Base.Git/Save-Topic.ps1
    cites:
      - FDR-GIT-USERRUNSGIT
---
#>

Describe 'Save-Topic' -Tag 'L0', 'logic', 'FDR-GIT-USERRUNSGIT' {
    BeforeAll {
        $script:config = [Catzc.Base.Git.GitFlowConfig]::new(@{})
        function Set-Git {
            param([string] $Branch = 'widget', [string] $Status = ' M widget.ps1', [bool] $MainViaPr = $false)
            $script:branch = $Branch
            $script:status = $Status
            $script:mainViaPr = $MainViaPr
            Mock Test-GitWorkspace -ModuleName Catzc.Base.Git { $script:mainViaPr }
            Mock Invoke-Executable -ModuleName Catzc.Base.Git {
                $output = switch -Wildcard ($Command) {
                    'git rev-parse*' {
                        $script:branch
                    }
                    'git status*' {
                        $script:status
                    }
                    default {
                        ''
                    }
                }
                [pscustomobject]@{ Output = $output; ExitCode = 0 }
            }
        }
    }

    BeforeEach {
        Mock Assert-Command -ModuleName Catzc.Base.Git { }
        Mock Write-Message -ModuleName Catzc.Base.Git { }
    }

    It 'stages every change and commits it with the message' {
        Set-Git
        $result = Save-Topic -Message 'spin the "widget"' -Config $script:config
        $result.Saved | Should -BeTrue
        $result.Branch | Should -BeExactly 'widget'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git add -A' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "spin the \"widget\""' }
    }

    It 'commits with ... when no message is given' {
        Set-Git
        (Save-Topic -Config $script:config).Message | Should -BeExactly '...'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "..."' }
    }

    It 'leaves a clean tree as it is' {
        Set-Git -Status ''
        (Save-Topic -Config $script:config).Saved | Should -BeFalse
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git add*' -or $Command -like 'git commit*' }
    }

    It 'refuses a detached HEAD' {
        Set-Git -Branch 'HEAD'
        { Save-Topic -Config $script:config } | Should -Throw '*needs a named branch*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git commit*' }
    }

    It 'refuses a main branch in main-via-pr, and allows it in main-direct' {
        Set-Git -Branch 'main' -MainViaPr $true
        { Save-Topic -Config $script:config } | Should -Throw "*main-via-pr and 'main' is checked out*"
        Set-Git -Branch 'main' -MainViaPr $false
        (Save-Topic -Config $script:config).Saved | Should -BeTrue
    }
}
