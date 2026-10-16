<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Write-TestRunContext.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Write-TestRunContext.ps1
---
#>

# Write-TestRunContext renders a fixture context record: one line per fact, under the banner.
Describe 'Write-TestRunContext' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'prints six labelled lines, with the location reason, the tier cap, and the tools present' {
        InModuleScope Catzc.Base.QualityGates {
            Write-TestRunContext -Context ([ordered]@{
                    entryPoint = 'Test-Automation'; run = 'source'; codeRoot = 'C:\widget\automation'
                    location = 'snapshot'; locationReason = '-Isolated'
                    tiersRequested = 'L0-L3'; tiersRunning = 'L0-L2'; tierCap = 'L3 skipped: snapshot location'
                    actor = 'Agent'; tools = [ordered]@{ git = $true; az = $false }; selection = 'all tests'
                })
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 6
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  entry point  Test-Automation · source run · code root C:\widget\automation' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  location     snapshot (-Isolated)' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  tiers        asked L0-L3 · running L0-L2 — L3 skipped: snapshot location' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq '  tools        git yes · az no' }
    }
}
