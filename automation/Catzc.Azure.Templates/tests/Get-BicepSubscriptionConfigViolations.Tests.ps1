Describe 'Get-BicepSubscriptionConfigViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:azure = [ordered]@{
            subscriptions = [ordered]@{
                core_lower = [ordered]@{ environments = @('alpha', 'beta', 'subn') }
                core_upper = [ordered]@{ environments = @('gamma', 'delta', 'subp') }
            }
        }
        $script:run = {
            param($Subscription, $Environment, $Config, $Location)
            & (Get-Module Catzc.Azure.Templates) {
                Get-BicepSubscriptionConfigViolations -Subscription $args[0] -Environment $args[1] -AzureConfig $args[2] -Location $args[3]
            } $Subscription $Environment $Config $Location
        }
    }

    It 'returns no violations for a subscription that serves the environment' {
        @(& $script:run 'core_lower' 'alpha' $script:azure 'configuration/core_lower/alpha.yml') | Should -BeNullOrEmpty
    }

    It 'flags a folder that is not a defined subscription' {
        $v = @(& $script:run 'bogus' 'alpha' $script:azure 'configuration/bogus/alpha.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*not a defined subscription*'
    }

    It 'flags an environment the subscription does not serve' {
        $v = @(& $script:run 'core_lower' 'gamma' $script:azure 'configuration/core_lower/gamma.yml')
        $v.Count | Should -Be 1
        $v[0] | Should -BeLike '*does not serve*'
    }
}
