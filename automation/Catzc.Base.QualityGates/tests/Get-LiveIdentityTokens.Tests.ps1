<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-LiveIdentityTokens' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:run = { & (Get-Module Catzc.Base.QualityGates) { Get-LiveIdentityTokens } }
    }

    BeforeEach {
        $script:declarations = @{
            'Catzc.Base.Widget' = @(
                @{ config = 'customer'; path = 'customers'; take = 'keys'; kind = 'customer-key'; suggest = 'a fixture customer (acme / globex)' }
                @{ config = 'customer'; path = 'customers.*.shortcode'; kind = 'customer-shortcode'; suggest = 'a fixture shortcode (ac / gx)' }
                @{ config = 'azure'; path = 'org'; kind = 'org'; suggest = 'the fixture org (tst)' }
                @{ config = 'azure'; path = 'subscriptions'; take = 'keys'; kind = 'subscription'; suggest = 'a fixture subscription' }
                @{ config = 'azure'; path = 'environments'; take = 'keys'; kind = 'environment'; suggest = 'a fixture environment'; match = 'position'; skip_when = 'per_subscription' }
                @{ config = 'azure'; path = 'environments.*.shortcode'; kind = 'environment-shortcode'; suggest = 'a fixture env shortcode'; match = 'position'; skip_when = 'per_subscription' }
            )
            'Catzc.Base.Gadget' = @(
                @{ config = 'ado'; path = 'project'; kind = 'ado-project'; suggest = 'a fixture project name' }
            )
        }
        $script:configOwner = @{ customer = 'Catzc.Base.Widget'; azure = 'Catzc.Base.Widget'; ado = 'Catzc.Base.Gadget' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'identity-tokens' -and $ListOwners } -MockWith {
            foreach ($module in @($declarations.Keys | Sort-Object)) {
                [pscustomobject]@{ Name = 'identity-tokens'; Module = $module; Path = "automation/$module/configs/identity-tokens.yml" }
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'identity-tokens' -and $Module } -MockWith {
            [Catzc.Base.QualityGates.IdentityTokensConfig]::new(@{ tokens = $declarations[$Module] })
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -ne 'identity-tokens' -and $ListOwners } -MockWith {
            [pscustomobject]@{ Name = $Config; Module = $configOwner[$Config]; Path = "automation/$($configOwner[$Config])/configs/$Config.yml" }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'customer' -and -not $ListOwners } -MockWith {
            [ordered]@{ customers = [ordered]@{ acme = @{ shortcode = 'ac' }; globex = @{ shortcode = 'gx' } } }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'azure' -and -not $ListOwners } -MockWith {
            [ordered]@{
                org           = 'tst'
                subscriptions = [ordered]@{ core_lower = @{}; acme_lower = @{} }
                environments  = [ordered]@{
                    alpha = @{ shortcode = 'al' }
                    beta  = @{ shortcode = 'bt' }
                    nsub  = @{ shortcode = 'ns'; per_subscription = $true }
                }
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'ado' -and -not $ListOwners } -MockWith {
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

    It 'excludes deployable-unit and pipeline names (Stage 1 — they collide with folder literals)' {
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

    It 'yields no config tokens when no loaded module declares any (a bundle without the owning modules)' {
        $declarations.Clear()
        $tokens = & $script:run
        ($tokens | Where-Object { $_.Source -like '*.yml' }) | Should -BeNullOrEmpty
        $tokens.Token | Should -Contain 'sample'
    }

    It 'rejects a declaration that names a config its own module does not own' {
        $declarations['Catzc.Base.Gadget'] = @(
            @{ config = 'azure'; path = 'org'; kind = 'org'; suggest = 'the fixture org (tst)' }
        )
        { & $script:run } | Should -Throw "*Catzc.Base.Gadget/configs/identity-tokens.yml declares tokens of config 'azure', which Catzc.Base.Gadget does not own*"
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
