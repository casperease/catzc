# Write-TestRunContext renders a fixture context record: one line per fact, under the banner.
Describe 'Write-TestRunContext' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'prints six labelled lines, with the slot reason, the tier cap, and the tools present' {
        InModuleScope Catzc.Base.QualityGates {
            Write-TestRunContext -Context ([ordered]@{
                    entryPoint = 'Test-Automation'; run = 'source'; codeRoot = 'C:\widget\automation'
                    slot = 'snapshot'; slotReason = '-Isolated'
                    tiersRequested = 'L0-L3'; tiersRunning = 'L0-L2'; tierCap = 'L3 skipped: snapshot slot'
                    actor = 'Agent'; tools = [ordered]@{ git = $true; az = $false }; selection = 'all tests'
                })
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 6
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  entry point  Test-Automation · source run · code root C:\widget\automation' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  slot         snapshot (-Isolated)' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  tiers        asked L0-L3 · running L0-L2 — L3 skipped: snapshot slot' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  tools        git yes · az no' }
    }
}
