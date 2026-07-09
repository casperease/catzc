Describe 'Get-BicepSubscriptionConfigViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture azure: a non-customer pair (the shared platform) + a customer pair (acme) + a second
        # rogue non-customer subscription that overlaps core_lower on beta (the root-ambiguity case).
        $script:azure = [ordered]@{
            subscriptions = [ordered]@{
                core_lower = [ordered]@{ environments = @('alpha', 'beta', 'nsub') }
                core_upper = [ordered]@{ environments = @('gamma', 'delta', 'psub') }
                rogue_beta = [ordered]@{ environments = @('beta') }
                acme_lower = [ordered]@{ customer = 'acme'; environments = @('alpha', 'nsub') }
                acme_upper = [ordered]@{ customer = 'acme'; environments = @('gamma', 'psub') }
            }
        }
        # The customer catalogue reads are whole-boundary mocks (ADR-AUTO-PESTER:3) — the rule needs the key
        # list, and the candidates rule normalizes a non-matching raw token through Get-AzureCustomer.
        Mock Get-AzureCustomers { @('acme', 'globex') } -ModuleName Catzc.Azure.Templates
        Mock Get-AzureCustomer { [ordered]@{ key = $Name; shortcode = ''; details = '' } } -ModuleName Catzc.Azure.Templates
        $script:run = {
            param($Customer, $Environment, $Config, $Location)
            & (Get-Module Catzc.Azure.Templates) {
                Get-BicepSubscriptionConfigViolations -Customer $args[0] -Environment $args[1] -AzureConfig $args[2] -Location $args[3]
            } $Customer $Environment $Config $Location
        }
    }

    It 'returns no violations for a root config whose env one non-customer subscription serves' {
        @(& $script:run '' 'alpha' $script:azure 'configuration/alpha.yml') | Should -BeNullOrEmpty
    }

    It 'returns no violations for a customer config whose env one customer subscription serves' {
        @(& $script:run 'acme' 'alpha' $script:azure 'configuration/acme/alpha.yml') | Should -BeNullOrEmpty
    }

    It 'flags a subfolder that is not a customer key' {
        $v = @(& $script:run 'bogus' 'alpha' $script:azure 'configuration/bogus/alpha.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*not a customer key*'
    }

    It 'flags a root config whose env no non-customer subscription serves' {
        # zeta is served by nobody; alpha only by a CUSTOMER subscription does not count for root.
        $v = @(& $script:run '' 'zeta' $script:azure 'configuration/zeta.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*cannot be resolved*no non-customer subscription*'
    }

    It 'flags a customer config whose env none of that customer''s subscriptions serve' {
        $v = @(& $script:run 'acme' 'beta' $script:azure 'configuration/acme/beta.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike "*customer 'acme' has no subscription serving*"
    }

    It 'flags a defined customer with no subscription at all' {
        $v = @(& $script:run 'globex' 'alpha' $script:azure 'configuration/globex/alpha.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*cannot be resolved*'
    }

    It 'flags a root config whose env more than one non-customer subscription serves (must be ONE subscription id)' {
        $v = @(& $script:run '' 'beta' $script:azure 'configuration/beta.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*more than one subscription*exactly one subscription id*'
    }
}
