Describe 'Get-RootConfigTargets' -Tag 'L0', 'logic' {
    It 'returns only the opted-in entries, in registry order' {
        $config = [pscustomobject]@{
            files = @(
                [pscustomobject]@{ target = 'a'; optIn = $true }
                [pscustomobject]@{ target = 'b'; optIn = $false }
                [pscustomobject]@{ target = 'c'; optIn = $true }
            )
        }
        $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
            param($Config) Get-RootConfigTargets -Config $Config
        }
        @($targets.target) | Should -Be @('a', 'c')
    }

    It 'returns an empty list when nothing is opted in' {
        $config = [pscustomobject]@{
            files = @([pscustomobject]@{ target = 'a'; optIn = $false })
        }
        $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
            param($Config) Get-RootConfigTargets -Config $Config
        }
        @($targets) | Should -HaveCount 0
    }
}
