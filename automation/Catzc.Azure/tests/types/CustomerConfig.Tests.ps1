Describe 'CustomerConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.CustomerConfig]::new($raw) }
    }

    Context 'integrity (shipped customer.yml)' -Tag 'integrity' {
        It 'passes for the shipped customer.yml' {
            Get-Config -Config customer | Should -BeOfType [Catzc.Azure.CustomerConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = & $script:make ([ordered]@{ customers = [ordered]@{ acme = [ordered]@{ shortcode = 'ac'; details = 'Acme' } } })
            $config.customers['acme'] | Should -BeOfType [Catzc.Azure.AzureCustomer]
            $config.customers['acme'].key | Should -Be 'acme'
            $config.customers['acme'].shortcode | Should -Be 'ac'
            $config.customers['acme'].details | Should -Be 'Acme'
        }

        It 'keeps the customers in file order' {
            $config = & $script:make ([ordered]@{ customers = [ordered]@{ globex = @{ shortcode = 'gx' }; acme = @{ shortcode = 'ac' } } })
            @($config.customers.Keys) | Should -Be @('globex', 'acme')
        }

        It 'passes for an empty customers map' {
            (& $script:make ([ordered]@{ customers = [ordered]@{} })).customers.Count | Should -Be 0
        }

        It 'throws when the customers key is missing' {
            { & $script:make ([ordered]@{ foo = 'bar' }) } | Should -Throw '*Missing required*customers*'
        }

        It 'throws when a customer is missing its shortcode' {
            { & $script:make ([ordered]@{ customers = [ordered]@{ acme = [ordered]@{ details = 'Acme' } } }) } |
                Should -Throw "*customer 'acme' is missing 'shortcode'*"
        }

        It 'throws when a shortcode is not 2 letters' {
            { & $script:make ([ordered]@{ customers = [ordered]@{ acme = [ordered]@{ shortcode = 'a' } } }) } | Should -Throw '*invalid shortcode*'
        }

        It 'throws for duplicate shortcodes' {
            $config = [ordered]@{ customers = [ordered]@{
                    acme   = [ordered]@{ shortcode = 'ac' }
                    globex = [ordered]@{ shortcode = 'ac' }
                }
            }
            { & $script:make $config } | Should -Throw '*Duplicate customer shortcode*'
        }

        It 'throws for an invalid customer name' {
            { & $script:make ([ordered]@{ customers = [ordered]@{ 'Bad-Name' = [ordered]@{ shortcode = 'bn' } } }) } |
                Should -Throw '*customer name*is invalid*'
        }

        It 'throws when a key collides with a shortcode (ambiguity guard)' -Tag 'ADR-AZ-CUSTOMER#2' {
            # 'gx' is a key AND globex's shortcode — a subscription reference to 'gx' would be ambiguous.
            $config = [ordered]@{ customers = [ordered]@{
                    globex = [ordered]@{ shortcode = 'gx' }
                    gx     = [ordered]@{ shortcode = 'zz' }
                }
            }
            { & $script:make $config } | Should -Throw '*collides with a customer shortcode*'
        }

        It 'throws on an unknown top-level or entry key' {
            $config = [ordered]@{ customers = [ordered]@{ acme = [ordered]@{ shortcode = 'ac'; colour = 'blue' } }; extra = 1 }
            $err = { & $script:make $config } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown top-level key 'extra'*"
            $err.Exception.Message | Should -BeLike "*customer 'acme': unknown key 'colour'*"
        }

        It 'reports every violation in one throw' {
            $config = [ordered]@{ customers = [ordered]@{
                    'Bad-Name' = [ordered]@{ shortcode = 'bn' }
                    acme       = [ordered]@{ shortcode = 'a' }
                    globex     = [ordered]@{ details = 'x' }
                }
            }
            $err = { & $script:make $config } | Should -Throw -PassThru
            foreach ($expected in '*customer name*Bad-Name*is invalid*', '*invalid shortcode*', "*customer 'globex' is missing 'shortcode'*") {
                $err.Exception.Message | Should -BeLike $expected
            }
        }
    }
}
