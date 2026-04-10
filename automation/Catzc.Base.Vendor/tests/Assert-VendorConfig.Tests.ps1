Describe 'Assert-VendorConfig' -Tag 'L0' {

    Context 'integrity (shipped vendor.yml)' -Tag 'integrity' {
        It 'passes for the shipped vendor.yml' {
            $config = Get-Config -Config vendor
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Not -Throw
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = [ordered]@{ source = 'PSGallery' }
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'passes with a valid custom sourceUrl' {
            $config = [ordered]@{ source = 'Feed'; sourceUrl = 'https://feed/v3/index.json' }
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'throws on an unknown key' {
            $config = [ordered]@{ source = 'PSGallery'; nope = 1 }
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Throw '*unknown key*'
        }

        It 'throws when source is missing' {
            $config = [ordered]@{ sourceUrl = 'https://feed/v3/index.json' }
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Throw '*source*'
        }

        It 'throws on a non-absolute sourceUrl' {
            $config = [ordered]@{ source = 'Feed'; sourceUrl = 'not a url' }
            { & (Get-Module Catzc.Base.Vendor) { Assert-VendorConfig $args[0] } $config } | Should -Throw '*sourceUrl*'
        }
    }
}
