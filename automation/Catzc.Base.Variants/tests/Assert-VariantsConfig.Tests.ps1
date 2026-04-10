Describe 'Assert-VariantsConfig' -Tag 'L0' {

    Context 'integrity (shipped variants.yml)' -Tag 'integrity' {
        It 'passes for the shipped variants.yml' {
            $config = Get-Config -Config variants
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = [ordered]@{ ado_naming = 'standard'; have_customers = $false }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'passes for an empty config (all keys default)' {
            $config = [ordered]@{}
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'accepts have_customers as the string all' {
            $config = [ordered]@{ have_customers = 'all' }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'accepts have_customers as a list of names' {
            $config = [ordered]@{ have_customers = @('acme', 'globex') }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'accepts have_customers as a boolean true' {
            $config = [ordered]@{ have_customers = $true }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'throws on an unknown key' {
            $config = [ordered]@{ ado_naming = 'standard'; bogus = 1 }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Throw '*unknown key*bogus*'
        }

        It 'throws on an invalid ado_naming' {
            $config = [ordered]@{ ado_naming = 'sideways' }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Throw '*invalid ado_naming*'
        }

        It 'throws when have_customers is a non-all string' {
            $config = [ordered]@{ have_customers = 'some' }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Throw "*a string must be 'all'*"
        }

        It 'throws when a have_customers list holds an invalid name' {
            $config = [ordered]@{ have_customers = @('acme', 'Bad-Name') }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Throw '*invalid have_customers customer name*'
        }

        It 'throws when a have_customers list has a duplicate name' {
            $config = [ordered]@{ have_customers = @('acme', 'acme') }
            { & (Get-Module Catzc.Base.Variants) { Assert-VariantsConfig $args[0] } $config } | Should -Throw '*duplicate have_customers customer name*'
        }
    }
}
