Describe 'Assert-ExporterConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        # One valid config; each case breaks exactly one thing in a copy of it.
        $script:newValidConfig = {
            [ordered]@{
                direct_install_version = '6.6.666'
                version                = '0.1'
                default_profile        = 'full'
                vendor_policy          = 'runtime'
                module_guid            = '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
                package                = [ordered]@{
                    author      = 'A'
                    company     = 'C'
                    description = 'D'
                    tags        = @('widget')
                    project_uri = 'https://forge.example/widget'
                    license_uri = 'https://forge.example/widget/license'
                }
            }
        }
    }

    It 'accepts a valid config' {
        $config = & $script:newValidConfig
        InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } {
            { Assert-ExporterConfig $Config } | Should -Not -Throw
        }
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'a non-GUID module_guid'; Key = 'module_guid'; Value = 'not-a-guid'; Expected = '*invalid module_guid*' }
        @{ Case = 'a MAJOR.MINOR.PATCH version (PATCH is calculated)'; Key = 'version'; Value = '0.1.0'; Expected = '*invalid version*' }
        @{ Case = 'a non-numeric version'; Key = 'version'; Value = 'v1'; Expected = '*invalid version*' }
        @{ Case = 'a non-numeric direct_install_version'; Key = 'direct_install_version'; Value = '6.6'; Expected = '*invalid direct_install_version*' }
        @{ Case = 'an invalid vendor_policy'; Key = 'vendor_policy'; Value = 'everything'; Expected = '*invalid vendor_policy*' }
        @{ Case = 'a non-token default_profile'; Key = 'default_profile'; Value = 'Full Set'; Expected = '*invalid default_profile*' }
    ) {
        $config = & $script:newValidConfig
        $config[$Key] = $Value
        { InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } { Assert-ExporterConfig $Config } } |
            Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects a missing required key' {
        $config = & $script:newValidConfig
        $config.Remove('default_profile')
        { InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } { Assert-ExporterConfig $Config } } |
            Should -Throw -ExpectedMessage "*missing required key 'default_profile'*"
    }

    It 'rejects an unknown key (a removed concept such as default_aspect included)' {
        $config = & $script:newValidConfig
        $config['default_aspect'] = 'live'
        { InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } { Assert-ExporterConfig $Config } } |
            Should -Throw -ExpectedMessage '*unknown key*default_aspect*'
    }

    It 'rejects a package missing <Field>' -ForEach @(
        @{ Field = 'author' }
        @{ Field = 'project_uri' }
        @{ Field = 'license_uri' }
    ) {
        $config = & $script:newValidConfig
        $config.package.Remove($Field)
        { InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } { Assert-ExporterConfig $Config } } |
            Should -Throw -ExpectedMessage "*package.$Field is required*"
    }

    It 'rejects a package with no tags' {
        $config = & $script:newValidConfig
        $config.package.tags = @()
        { InModuleScope Catzc.Base.Exporter -Parameters @{ Config = $config } { Assert-ExporterConfig $Config } } |
            Should -Throw -ExpectedMessage '*package.tags is required*'
    }
}

Describe 'exporter.yml' -Tag 'L0', 'integrity' {
    It 'the shipped export config passes its validator' {
        { Get-Config -Config exporter } | Should -Not -Throw
    }
}
