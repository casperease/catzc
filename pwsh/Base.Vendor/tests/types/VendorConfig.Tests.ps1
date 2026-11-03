Describe 'VendorConfig' -Tag 'L0' {

    Context 'integrity (shipped vendor.yml)' -Tag 'integrity' {
        It 'passes for the shipped vendor.yml' {
            Get-Config -Config vendor | Should -BeOfType [Catzc.Base.Vendor.VendorConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'takes the public gallery when package_source is absent' {
            foreach ($raw in [ordered]@{}, $null) {
                [Catzc.Base.Vendor.VendorConfig]::new($raw).package_source | Should -Be ([Catzc.Base.Languages.PackageSource]::PSGallery)
            }
        }

        It 'reads a declared package_source' {
            $config = [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ package_source = [ordered]@{ name = 'widgetfeed'; url = 'https://feed.widget.test/v3/index.json' } })
            $config.package_source.name | Should -Be 'widgetfeed'
            $config.package_source.url | Should -Be 'https://feed.widget.test/v3/index.json'
            $config.Contains('package_source') | Should -BeTrue
        }

        It 'throws on an unknown key, and on the keys the package_source replaced' {
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ nope = 1 }) } | Should -Throw '*unknown key*'
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ source = 'PSGallery' }) } | Should -Throw "*unknown key 'source'*"
        }

        It 'throws on a non-https package_source url, naming the key' {
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ package_source = [ordered]@{ url = 'not a url' } }) } |
                Should -Throw '*package_source.url*'
        }

        It 'reports every violation in one throw' {
            $err = { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ nope = 1; package_source = [ordered]@{ url = 'not a url' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*invalid package_source.url 'not a url'*"
        }
    }
}
