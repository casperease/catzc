Describe 'Get-TestAutomationTestPaths' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:paths = @(InModuleScope Catzc.Base.QualityGates { Get-TestAutomationTestPaths })
    }

    It 'returns existing tests folders only, for the whole tree' {
        $script:paths.Count | Should -BeGreaterThan 10
        foreach ($path in $script:paths) {
            [System.IO.Path]::GetFileName($path) | Should -Be 'tests'
            $path | Should -Exist
        }
    }

    It 'puts dot-prefixed infrastructure after every module' {
        $isInfra = @(foreach ($path in $script:paths) {
                [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($path)).StartsWith('.')
            })
        # Once the list switches to infrastructure it never switches back — modules first, infra last.
        $firstInfra = [array]::IndexOf([bool[]] $isInfra, $true)
        if ($firstInfra -ge 0) {
            @($isInfra[$firstInfra..($isInfra.Count - 1)]) | Should -Not -Contain $false
        }
    }

    It 'narrows to the named modules and drops infrastructure when filtered' {
        $narrowed = @(InModuleScope Catzc.Base.QualityGates {
                Get-TestAutomationTestPaths -Modules 'Catzc.Base.QualityGates'
            })
        $narrowed | Should -HaveCount 1
        $narrowed[0] | Should -BeLike '*Catzc.Base.QualityGates*tests'
    }
}
