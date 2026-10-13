Describe 'ExporterConfig' -Tag 'L0', 'logic' {
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
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Exporter.ExporterConfig]::new($raw) }
    }

    It 'accepts a valid config and maps every key' {
        $config = & $script:make (& $script:newValidConfig)
        $config.direct_install_version | Should -Be '6.6.666'
        $config.version | Should -Be '0.1'
        $config.default_profile | Should -Be 'full'
        $config.vendor_policy | Should -Be 'runtime'
        $config.module_guid | Should -Be '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
        $config.package | Should -BeOfType [Catzc.Base.Exporter.ExporterPackage]
        $config.package.author | Should -Be 'A'
        $config.package.tags | Should -Be @('widget')
        $config.package.license_uri | Should -Be 'https://forge.example/widget/license'
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
        { & $script:make $config } | Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects a missing required key' {
        $config = & $script:newValidConfig
        $config.Remove('default_profile')
        { & $script:make $config } | Should -Throw -ExpectedMessage "*missing required key 'default_profile'*"
    }

    It 'rejects an unknown key (a removed concept such as default_aspect included)' {
        $config = & $script:newValidConfig
        $config['default_aspect'] = 'live'
        { & $script:make $config } | Should -Throw -ExpectedMessage '*unknown key*default_aspect*'
    }

    It 'rejects a package missing <Field>' -ForEach @(
        @{ Field = 'author' }
        @{ Field = 'project_uri' }
        @{ Field = 'license_uri' }
    ) {
        $config = & $script:newValidConfig
        $config.package.Remove($Field)
        { & $script:make $config } | Should -Throw -ExpectedMessage "*package.$Field is required*"
    }

    It 'rejects a package with no tags' {
        $config = & $script:newValidConfig
        $config.package.tags = @()
        { & $script:make $config } | Should -Throw -ExpectedMessage '*package.tags is required*'
    }

    It 'reports every violation in one throw' {
        $config = & $script:newValidConfig
        $config.version = 'v1'
        $config.vendor_policy = 'everything'
        $config.package.Remove('author')
        $err = { & $script:make $config } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike '*invalid version*'
        $err.Exception.Message | Should -BeLike '*invalid vendor_policy*'
        $err.Exception.Message | Should -BeLike '*package.author is required*'
    }
}

Describe 'exporter.yml' -Tag 'L0', 'integrity' {
    It 'the shipped export config passes its validator' {
        Get-Config -Config exporter | Should -BeOfType [Catzc.Base.Exporter.ExporterConfig]
    }
}
