Describe 'Assert-CustomerConfig' -Tag 'L0' {

    Context 'integrity (shipped customer.yml)' -Tag 'integrity' {
        It 'passes for the shipped customer.yml' {
            $config = Get-Config -Config customer
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Not -Throw
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = [ordered]@{ customers = [ordered]@{ acme = [ordered]@{ shortcode = 'ac'; details = 'Acme' } } }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'passes for an empty customers map' {
            $config = [ordered]@{ customers = [ordered]@{} }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'throws when the customers key is missing' {
            $config = [ordered]@{ foo = 'bar' }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw '*Missing required*customers*'
        }

        It 'throws when a customer is missing its shortcode' {
            $config = [ordered]@{ customers = [ordered]@{ acme = [ordered]@{ details = 'Acme' } } }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw "*customer 'acme' is missing 'shortcode'*"
        }

        It 'throws when a shortcode is not 2 letters' {
            $config = [ordered]@{ customers = [ordered]@{ acme = [ordered]@{ shortcode = 'a' } } }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw '*invalid shortcode*'
        }

        It 'throws for duplicate shortcodes' {
            $config = [ordered]@{ customers = [ordered]@{
                    acme   = [ordered]@{ shortcode = 'ac' }
                    globex = [ordered]@{ shortcode = 'ac' }
                }
            }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw '*Duplicate customer shortcode*'
        }

        It 'throws for an invalid customer name' {
            $config = [ordered]@{ customers = [ordered]@{ 'Bad-Name' = [ordered]@{ shortcode = 'bn' } } }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw '*customer name*is invalid*'
        }

        It 'throws when a key collides with a shortcode (ambiguity guard)' {
            # 'gx' is a key AND globex's shortcode — a subscription reference to 'gx' would be ambiguous.
            $config = [ordered]@{ customers = [ordered]@{
                    globex = [ordered]@{ shortcode = 'gx' }
                    gx     = [ordered]@{ shortcode = 'zz' }
                }
            }
            { & (Get-Module Catzc.Azure) { Assert-CustomerConfig $args[0] } $config } | Should -Throw '*collides with a customer shortcode*'
        }
    }
}
