Describe 'Get-TestRunWorkerEnvironment' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-POSTBUILDTAG' {
    It 'blocks every real launch below the first real-process tier' {
        $environment = InModuleScope Catzc.Base.QualityGates {
            Get-TestRunWorkerEnvironment -MaxLevel ([Catzc.Base.Timeouts.TestTiers]::FirstRealProcessTier - 1)
        }
        $environment.CATZC_BLOCK_REAL_PROCESS | Should -Be ([Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch)
    }

    It 'blocks by tier from the first real-process tier up' {
        $environment = InModuleScope Catzc.Base.QualityGates {
            Get-TestRunWorkerEnvironment -MaxLevel ([Catzc.Base.Timeouts.TestTiers]::FirstRealProcessTier)
        }
        $environment.CATZC_BLOCK_REAL_PROCESS | Should -Be ([Catzc.Base.Timeouts.TestTiers]::BlockByTier)
    }
}
