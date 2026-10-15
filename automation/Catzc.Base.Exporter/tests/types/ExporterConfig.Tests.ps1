<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/tests/types/ExporterConfig.Tests.ps1
    kind: test
---
#>

Describe 'ExporterConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        # One valid config; each case breaks exactly one thing in a copy of it.
        $script:newValidConfig = {
            [ordered]@{
                direct_install_version = '6.6.666'
                bundles                = [ordered]@{
                    widgets = [ordered]@{ profile = 'widget-set'; version = '0.1' }
                    gadgets = [ordered]@{ profile = 'gadget-set'; version = '2.3'; vendor_policy = 'full' }
                }
                default_bundle         = 'widgets'
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
        $config.default_bundle | Should -Be 'widgets'
        $config.module_guid | Should -Be '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
        $config.package | Should -BeOfType [Catzc.Base.Exporter.ExporterPackage]
        $config.package.author | Should -Be 'A'
        $config.package.tags | Should -Be @('widget')
        $config.package.license_uri | Should -Be 'https://forge.example/widget/license'
    }

    It 'maps each bundle on its own version line, defaulting vendor_policy to runtime' {
        $config = & $script:make (& $script:newValidConfig)
        @($config.bundles.Keys) | Should -Be @('widgets', 'gadgets')
        $config.bundles['widgets'] | Should -BeOfType [Catzc.Base.Exporter.ExporterBundle]
        $config.bundles['widgets'].name | Should -Be 'widgets'
        $config.bundles['widgets'].profile | Should -Be 'widget-set'
        $config.bundles['widgets'].version | Should -Be '0.1'
        $config.bundles['widgets'].vendor_policy | Should -Be 'runtime'
        $config.bundles['gadgets'].version | Should -Be '2.3'
        $config.bundles['gadgets'].vendor_policy | Should -Be 'full'
    }

    It 'maps footprint limits, absent meaning no limit' {
        $raw = & $script:newValidConfig
        $raw.bundles.gadgets['max_files'] = 120
        $raw.bundles.gadgets['max_bytes'] = 4000000
        $config = & $script:make $raw
        $config.bundles['gadgets'].max_files | Should -Be 120
        $config.bundles['gadgets'].max_bytes | Should -Be 4000000
        $config.bundles['widgets'].max_files | Should -BeNullOrEmpty
        $config.bundles['widgets'].max_bytes | Should -BeNullOrEmpty
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'a non-GUID module_guid'; Key = 'module_guid'; Value = 'not-a-guid'; Expected = '*invalid module_guid*' }
        @{ Case = 'a non-numeric direct_install_version'; Key = 'direct_install_version'; Value = '6.6'; Expected = '*invalid direct_install_version*' }
        @{ Case = 'a default_bundle that is not a bundle'; Key = 'default_bundle'; Value = 'sprockets'; Expected = "*default_bundle 'sprockets' is not one of the bundles*" }
        @{ Case = 'no bundles'; Key = 'bundles'; Value = [ordered]@{}; Expected = '*bundles is required*' }
    ) {
        $config = & $script:newValidConfig
        $config[$Key] = $Value
        { & $script:make $config } | Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects a bundle with <Case>' -ForEach @(
        @{ Case = 'a MAJOR.MINOR.PATCH version (PATCH is calculated)'; Key = 'version'; Value = '0.1.0'; Expected = "*bundles.widgets: invalid version '0.1.0'*" }
        @{ Case = 'a non-numeric version'; Key = 'version'; Value = 'v1'; Expected = '*bundles.widgets: invalid version*' }
        @{ Case = 'an invalid vendor_policy'; Key = 'vendor_policy'; Value = 'everything'; Expected = '*bundles.widgets: invalid vendor_policy*' }
        @{ Case = 'a non-token profile'; Key = 'profile'; Value = 'Widget Set'; Expected = '*bundles.widgets: invalid profile*' }
        @{ Case = 'an unknown key'; Key = 'carries_widgets'; Value = $true; Expected = "*bundles.widgets: unknown key 'carries_widgets'*" }
        @{ Case = 'a zero max_files'; Key = 'max_files'; Value = 0; Expected = "*bundles.widgets: invalid max_files '0'*" }
        @{ Case = 'a non-numeric max_bytes'; Key = 'max_bytes'; Value = '5MB'; Expected = "*bundles.widgets: invalid max_bytes '5MB'*" }
    ) {
        $config = & $script:newValidConfig
        $config.bundles.widgets[$Key] = $Value
        { & $script:make $config } | Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects a bundle missing its <Key>' -ForEach @(
        @{ Key = 'profile' }
        @{ Key = 'version' }
    ) {
        $config = & $script:newValidConfig
        $config.bundles.widgets.Remove($Key)
        { & $script:make $config } | Should -Throw -ExpectedMessage "*bundles.widgets: missing required key '$Key'*"
    }

    It 'rejects a bundle name that is not a lowercase token' {
        $config = & $script:newValidConfig
        $config.bundles['Widget Set'] = [ordered]@{ profile = 'widget-set'; version = '0.1' }
        { & $script:make $config } | Should -Throw -ExpectedMessage "*invalid bundle name 'Widget Set'*"
    }

    It 'rejects a missing required key' {
        $config = & $script:newValidConfig
        $config.Remove('default_bundle')
        { & $script:make $config } | Should -Throw -ExpectedMessage "*missing required key 'default_bundle'*"
    }

    It 'rejects an unknown key (a removed concept such as default_profile included)' {
        $config = & $script:newValidConfig
        $config['default_profile'] = 'full'
        { & $script:make $config } | Should -Throw -ExpectedMessage '*unknown key*default_profile*'
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
        $config.bundles.widgets.version = 'v1'
        $config.bundles.gadgets.vendor_policy = 'everything'
        $config.package.Remove('author')
        $err = { & $script:make $config } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike '*bundles.widgets: invalid version*'
        $err.Exception.Message | Should -BeLike '*bundles.gadgets: invalid vendor_policy*'
        $err.Exception.Message | Should -BeLike '*package.author is required*'
    }
}

Describe 'exporter.yml' -Tag 'L0', 'integrity' {
    It 'the shipped export config passes its validator' {
        Get-Config -Config exporter | Should -BeOfType [Catzc.Base.Exporter.ExporterConfig]
    }

    It 'every bundle names a profile that profiles.yml declares' {
        $profiles = (Get-Config -Config profiles).profiles
        foreach ($bundle in (Get-Config -Config exporter).bundles.Values) {
            $profiles.Keys | Should -Contain $bundle.profile -Because "bundle '$($bundle.name)' builds profile '$($bundle.profile)'"
        }
    }
}
