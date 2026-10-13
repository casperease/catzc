Describe 'Resolve-TestRunMaxLevel' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        $script:inPlace = [pscustomobject]@{ Mode = 'InPlace'; Holder = $null }
        $script:snapshot = [pscustomobject]@{ Mode = 'Snapshot'; Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 4242)' } }
        $script:isolated = [pscustomobject]@{ Mode = 'Snapshot'; Holder = $null }

        function Invoke-Resolve {
            param($Slot, $Requested)
            $parameters = @{ S = $Slot; R = $Requested }
            InModuleScope Catzc.Base.QualityGates -Parameters $parameters {
                param($S, $R)
                if ($null -eq $R) {
                    Resolve-TestRunMaxLevel -Slot $S
                }
                else {
                    Resolve-TestRunMaxLevel -Slot $S -Requested $R
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

    It 'caps a snapshot run at L2 and says it skips L3, naming the holder' {
        Invoke-Resolve $script:snapshot $null | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Message -like 'Skipping L3:*working-folder slot*Test-Automation (pid 4242) holds it*'
        }
    }

    It 'caps an explicit L3 request in a snapshot too' {
        Invoke-Resolve $script:snapshot 3 | Should -Be 2
    }

    It 'caps an -Isolated snapshot (no holder) and still says so' {
        Invoke-Resolve $script:isolated $null | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like 'Skipping L3:*slot.' }
    }

    It 'leaves a request below L3 untouched in a snapshot, silently' {
        Invoke-Resolve $script:snapshot 2 | Should -Be 2
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
