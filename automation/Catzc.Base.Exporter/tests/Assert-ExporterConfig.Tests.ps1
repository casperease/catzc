Describe 'Assert-ExporterConfig' -Tag 'L0', 'logic' {
    It 'accepts a valid config' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'
                version                = '0.1.0'
                default_profile        = 'full'
                default_aspect         = 'live'
                vendor_policy          = 'runtime'
            }
            { Assert-ExporterConfig $config } | Should -Not -Throw
        }
    }

    It 'rejects an unknown key' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'; version = '0.1.0'
                default_profile = 'full'; default_aspect = 'live'; vendor_policy = 'runtime'
                bogus = 'x'
            }
            { Assert-ExporterConfig $config } | Should -Throw -ExpectedMessage '*unknown key*bogus*'
        }
    }

    It 'rejects a non-numeric version' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'; version = 'v1'
                default_profile = 'full'; default_aspect = 'live'; vendor_policy = 'runtime'
            }
            { Assert-ExporterConfig $config } | Should -Throw -ExpectedMessage '*invalid version*'
        }
    }

    It 'rejects a missing required key' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'; version = '0.1.0'
                default_aspect = 'live'; vendor_policy = 'runtime'
            }
            { Assert-ExporterConfig $config } | Should -Throw -ExpectedMessage "*missing required key 'default_profile'*"
        }
    }

    It 'rejects an invalid aspect' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'; version = '0.1.0'
                default_profile = 'full'; default_aspect = 'partial'; vendor_policy = 'runtime'
            }
            { Assert-ExporterConfig $config } | Should -Throw -ExpectedMessage '*invalid default_aspect*'
        }
    }

    It 'rejects an invalid vendor_policy' {
        InModuleScope Catzc.Base.Exporter {
            $config = [ordered]@{
                direct_install_version = '6.6.666'; version = '0.1.0'
                default_profile = 'full'; default_aspect = 'live'; vendor_policy = 'everything'
            }
            { Assert-ExporterConfig $config } | Should -Throw -ExpectedMessage '*invalid vendor_policy*'
        }
    }
}
