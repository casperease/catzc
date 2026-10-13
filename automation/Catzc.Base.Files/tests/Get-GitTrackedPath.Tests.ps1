Describe 'Get-GitTrackedPath' -Tag 'L0', 'logic' {
    It 'returns every tracked path git lists' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = (@('automation/widget/configs/gadget.yml', 'automation/widget/configs/widget.yml', '') -join "`n") }
        } -ModuleName Catzc.Base.Files
        Get-GitTrackedPath 'automation/widget/configs' |
            Should -Be @('automation/widget/configs/gadget.yml', 'automation/widget/configs/widget.yml')
    }

    It 'returns nothing when git tracks none of the paths' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        @(Get-GitTrackedPath 'automation/widget/configs/gadget.yml').Count | Should -Be 0
    }

    It 'quotes every path into one pathspec-limited ls-files call with literal paths' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        Get-GitTrackedPath 'automation/widget', 'docs' | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git -c core.quotepath=off ls-files -- "automation/widget" "docs"'
        }
    }
}
