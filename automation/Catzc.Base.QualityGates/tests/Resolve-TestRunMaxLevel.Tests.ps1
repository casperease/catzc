<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Resolve-TestRunMaxLevel.Tests.ps1
    folder: tests
    name: resolve-test-run-max-level-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Resolve-TestRunMaxLevel' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        $script:inPlace = [pscustomobject]@{ Mode = 'in-place'; Holder = $null; SystemTests = $true; SystemTestHolder = $null }
        $script:snapshot = [pscustomobject]@{
            Mode = 'snapshot'; Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 4242)' }; SystemTests = $false; SystemTestHolder = $null
        }
        $script:isolated = [pscustomobject]@{ Mode = 'snapshot'; Holder = $null; SystemTests = $false; SystemTestHolder = $null }
        # In place, but another checkout's run holds the user's system-test lock.
        $script:inPlaceLocked = [pscustomobject]@{
            Mode = 'in-place'; Holder = $null; SystemTests = $false
            SystemTestHolder = [pscustomobject]@{ Description = 'Test-Automation (pid 4343, in C:\widget-clone)' }
        }

        function Invoke-Resolve {
            param($Location, $Requested)
            $parameters = @{ L = $Location; R = $Requested }
            InModuleScope Catzc.Base.QualityGates -Parameters $parameters {
                param($L, $R)
                if ($null -eq $R) {
                    Resolve-TestRunMaxLevel -Location $L
                }
                else {
                    Resolve-TestRunMaxLevel -Location $L -Requested $R
                }
            }
        }
    }

    It 'runs every tier in place by default' {
        Invoke-Resolve $script:inPlace $null | Should -Be 3
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'keeps a lower requested level in place' {
        Invoke-Resolve $script:inPlace 1 | Should -Be 1
    }

    It 'runs the opt-in L4 in place when it is asked for' {
        Invoke-Resolve $script:inPlace 4 | Should -Be 4
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'caps an L4 request in a snapshot at L2, and says it skips L3 and L4' {
        Invoke-Resolve $script:snapshot 4 | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like 'Skipping L3 and L4:*' }
    }

    It 'caps a snapshot run at L2 and says it skips L3, naming the holder' {
        Invoke-Resolve $script:snapshot $null | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Message -like 'Skipping L3:*working folder itself*Test-Automation (pid 4242) holds it*'
        }
    }

    It 'caps an explicit L3 request in a snapshot too' {
        Invoke-Resolve $script:snapshot 3 | Should -Be 2
    }

    It 'caps an -Isolated snapshot (no holder) and still says so' {
        Invoke-Resolve $script:isolated $null | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like 'Skipping L3:*working folder itself.' }
    }

    It 'leaves a request below L3 untouched in a snapshot, silently' {
        Invoke-Resolve $script:snapshot 2 | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'caps an in-place run at L2 when another checkout holds the system-test lock, naming it' {
        Invoke-Resolve $script:inPlaceLocked $null | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Message -like 'Skipping L3:*pid 4343, in C:\widget-clone*system-test lock*'
        }
    }

    It 'leaves a request below L3 untouched in place without the system-test lock, silently' {
        Invoke-Resolve $script:inPlaceLocked 2 | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'fails an L3-only run that cannot take the system-test lock, naming the holder' {
        $parameters = @{ L = $script:inPlaceLocked }
        { InModuleScope Catzc.Base.QualityGates -Parameters $parameters { param($L) Resolve-TestRunMaxLevel -Location $L -MinLevel 3 } } |
            Should -Throw -ExpectedMessage '*pid 4343*holds the system-test lock*'
    }
}
