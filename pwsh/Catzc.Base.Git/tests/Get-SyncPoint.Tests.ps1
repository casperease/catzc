<#
---
catzc:
  immutable:
    with_body_sha: c58bf4496ca1
  edges:
    code: pwsh/Catzc.Base.Git/Get-SyncPoint.ps1
    cites:
      - FDR-GIT-SYNCPOINT
      - FDR-GIT-FALLBACKISANNOUNCED
---
#>

Describe 'Get-SyncPoint' -Tag 'L0', 'logic', 'FDR-GIT-SYNCPOINT' {
    BeforeAll {
        $script:main = 'a' * 40
        $script:verified = 'b' * 40
        $script:tagObject = 'c' * 40
        function Set-Remote {
            param([string[]] $Lines)
            $script:listing = $Lines -join "`n"
            Mock Invoke-Executable -ModuleName Catzc.Base.Git { [pscustomobject]@{ Output = $script:listing; ExitCode = 0 } }
        }
    }

    BeforeEach {
        Mock Assert-Command -ModuleName Catzc.Base.Git { }
        Mock Write-Message -ModuleName Catzc.Base.Git { }
    }

    It 'falls back to the current server HEAD of the first main branch, and says so' -Tag 'FDR-GIT-FALLBACKISANNOUNCED' {
        Set-Remote @("$script:main`tHEAD", "$script:main`trefs/heads/master", "$('d' * 40)`trefs/heads/widget")
        $point = Get-SyncPoint -Config ([Catzc.Base.Git.GitFlowConfig]::new(@{}))
        $point.Commit | Should -BeExactly $script:main
        $point.Source | Should -BeExactly 'fallback'
        $point.Branch | Should -BeExactly 'master'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter {
            $Warning -and $Message -like "*current server HEAD $script:main of 'master'*marks no BVT-verified head*"
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git ls-remote origin' }
    }

    It 'takes the BVT-verified head when the marked ref is on the server, preferring an annotated tag''s commit' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{ bvt_mark = @{ ref = 'refs/tags/widget-verified' } })
        Set-Remote @("$script:main`trefs/heads/main", "$script:tagObject`trefs/tags/widget-verified", "$script:verified`trefs/tags/widget-verified^{}")
        $point = Get-SyncPoint -Config $config
        $point.Commit | Should -BeExactly $script:verified
        $point.Source | Should -BeExactly 'bvt'
        $point.Branch | Should -BeExactly 'main'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 0 -Exactly -ParameterFilter { $Warning }
    }

    It 'falls back and names the missing mark when the marked ref is not on the server' -Tag 'FDR-GIT-FALLBACKISANNOUNCED' {
        $config = [Catzc.Base.Git.GitFlowConfig]::new(@{ bvt_mark = @{ ref = 'refs/heads/widget-verified' } })
        Set-Remote @("$script:main`trefs/heads/main")
        $point = Get-SyncPoint -Config $config
        $point.Source | Should -BeExactly 'fallback'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter {
            $Warning -and $Message -like "*the BVT mark 'refs/heads/widget-verified' is not on the server*"
        }
    }

    It 'stops when the server has none of the main branches' {
        Set-Remote @("$script:main`trefs/heads/widget")
        { Get-SyncPoint -Config ([Catzc.Base.Git.GitFlowConfig]::new(@{})) } | Should -Throw '*has none of the main branches main, master*'
    }
}
