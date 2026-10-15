<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/tests/types/VendorConfig.Tests.ps1
    kind: pester-test
---
#>

Describe 'VendorConfig' -Tag 'L0' {

    Context 'integrity (shipped vendor.yml)' -Tag 'integrity' {
        It 'passes for the shipped vendor.yml' {
            Get-Config -Config vendor | Should -BeOfType [Catzc.Base.Vendor.VendorConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ source = 'PSGallery' })
            $config.source | Should -Be 'PSGallery'
            $config.Contains('sourceUrl') | Should -BeFalse
        }

        It 'passes with a valid custom sourceUrl' {
            $config = [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ source = 'Feed'; sourceUrl = 'https://feed/v3/index.json' })
            $config.sourceUrl | Should -Be 'https://feed/v3/index.json'
            $config.Contains('sourceUrl') | Should -BeTrue
        }

        It 'throws on an unknown key' {
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ source = 'PSGallery'; nope = 1 }) } | Should -Throw '*unknown key*'
        }

        It 'throws when source is missing' {
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ sourceUrl = 'https://feed/v3/index.json' }) } | Should -Throw '*source*'
        }

        It 'throws on a non-absolute sourceUrl' {
            { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ source = 'Feed'; sourceUrl = 'not a url' }) } | Should -Throw '*sourceUrl*'
        }

        It 'reports every violation in one throw' {
            $err = { [Catzc.Base.Vendor.VendorConfig]::new([ordered]@{ nope = 1; sourceUrl = 'not a url' }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*missing required key 'source'*"
            $err.Exception.Message | Should -BeLike "*invalid sourceUrl 'not a url'*"
        }
    }
}
