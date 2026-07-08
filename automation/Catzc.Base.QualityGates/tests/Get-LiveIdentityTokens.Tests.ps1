Describe 'Get-LiveIdentityTokens' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:run = { & (Get-Module Catzc.Base.QualityGates) { Get-LiveIdentityTokens } }
    }

    BeforeEach {
        # Fixture configs through the Get-Config seam — the derivation must reflect exactly what the shipped
        # config declares, never a hand-kept list. The 'live' identities here are the fixture identities the
        # mocked config declares; the derivation logic is identical against the real config (ADR-TEST:3).
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'customer' } -MockWith {
            [ordered]@{ customers = [ordered]@{ acme = @{ shortcode = 'ac' }; globex = @{ shortcode = 'gx' } } }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'azure' } -MockWith {
            [ordered]@{
                org           = 'tst'
                subscriptions = [ordered]@{ core_lower = @{}; acme_lower = @{} }
                environments  = [ordered]@{
                    alpha = @{ shortcode = 'al' }
                    beta  = @{ shortcode = 'bt' }
                    nsub  = @{ shortcode = 'sn'; per_subscription = $true }
                }
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'ado' } -MockWith {
            [ordered]@{ project = 'FixtureProject' }
        }
        Mock Get-RepositoryRoot { $TestDrive } -ModuleName Catzc.Base.QualityGates
        [void][System.IO.Directory]::CreateDirectory((Join-Path $TestDrive 'infrastructure/templates/sample'))
    }

    It 'derives customers (keys and shortcodes) from customer.yml' {
        $tokens = & $script:run
        $tokens.Token | Should -Contain 'acme'
        $tokens.Token | Should -Contain 'globex'
        $tokens.Token | Should -Contain 'ac'
        $tokens.Token | Should -Contain 'gx'
    }

    It 'derives the org and subscription names from azure.yml' {
        $tokens = & $script:run
        ($tokens | Where-Object { $_.Token -eq 'tst' }).Kind | Should -Be 'org'
        $tokens.Token | Should -Contain 'core_lower'
        $tokens.Token | Should -Contain 'acme_lower'
    }

    It 'excludes deployable-unit and pipeline names (Phase 1 — they collide with folder literals)' {
        $tokens = & $script:run
        ($tokens | Where-Object { $_.Kind -in 'deployable-unit', 'pipeline' }) | Should -BeNullOrEmpty
    }

    It 'derives environments as position-match tokens, excluding the shared nsub/psub identity envs' {
        $tokens = & $script:run
        $envs = @($tokens | Where-Object { $_.Kind -eq 'environment' })
        $envs.Token | Should -Contain 'alpha'
        $envs.Token | Should -Contain 'beta'
        $envs.Token | Should -Not -Contain 'nsub'
        ($envs | ForEach-Object { $_.MatchMode } | Select-Object -Unique) | Should -Be 'position'
        ($tokens | Where-Object { $_.Token -eq 'al' }).Kind | Should -Be 'environment-shortcode'
    }

    It 'marks distinctive identities exact and environment identities position' {
        $tokens = & $script:run
        ($tokens | Where-Object { $_.Token -eq 'acme' }).MatchMode | Should -Be 'exact'
        ($tokens | Where-Object { $_.Token -eq 'tst' }).MatchMode | Should -Be 'exact'
        ($tokens | Where-Object { $_.Token -eq 'alpha' }).MatchMode | Should -Be 'position'
    }

    It 'derives the ADO project and shipped template names' {
        $tokens = & $script:run
        $tokens.Token | Should -Contain 'FixtureProject'
        $tokens.Token | Should -Contain 'sample'
    }

    It 'carries a Source and a Suggest for every token, de-duplicated' {
        $tokens = & $script:run
        foreach ($t in $tokens) {
            $t.Source | Should -Not -BeNullOrEmpty
            $t.Suggest | Should -Not -BeNullOrEmpty
        }
        ($tokens.Token | Select-Object -Unique).Count | Should -Be $tokens.Count
    }
}
