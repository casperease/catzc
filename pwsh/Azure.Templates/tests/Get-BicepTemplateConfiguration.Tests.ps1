# cspell:ignore alweufxoscusacst alweufxoscusst wdgt
Describe 'Get-BicepTemplateConfiguration' -Tag 'L0', 'logic' {
    # Read-only resolver: mocks and the cache reset run once, since the mocked config is identical every test and none mutates it.
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'loads alpha configuration with a ParametersFile' {
        $configuration = Get-BicepTemplateConfiguration sample alpha
        $configuration.ParametersFile | Should -Not -BeNullOrEmpty
        $configuration.ParametersFile.Contains('parameters') | Should -BeTrue
    }

    It 'loads beta configuration' {
        $configuration = Get-BicepTemplateConfiguration sample beta
        $configuration.ParametersFile.Contains('parameters') | Should -BeTrue
    }

    It 'returns a bicepparam slot''s source path, and a yml slot''s descriptor beside it' {
        $bicepparam = Get-BicepTemplateConfiguration sample-bicepparam alpha
        $bicepparam.BicepParamFile | Should -BeLike '*sample-bicepparam*configuration*alpha.bicepparam'
        $bicepparam.Contains('ParametersFile') | Should -BeFalse
        (Get-BicepTemplateConfiguration sample-bicepparam beta).ParametersFile.parameters.storageAccountName.value |
            Should -BeExactly 'btweufxosbppst'
    }

    It 'a bicepparam slot''s descriptor carries the ResourceGroup of the fixture''s sibling yml' {
        (Get-BicepTemplateConfiguration sample-bicepparam alpha).ResourceGroup | Should -BeExactly 'alpha-weu-fxo-sbpp-rg'
    }

    It 'a bicepparam slot''s descriptor carries the ResourceGroup its sibling yml declares' {
        $folder = Join-Path $TestDrive 'widget/configuration'
        [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $folder 'alpha.bicepparam'), "using '../main.bicep'`n")
        [System.IO.File]::WriteAllText((Join-Path $folder 'alpha.yml'), "ResourceGroup: alpha-weu-fxo-wdgt-rg`n")
        $script:widgetFolder = $folder
        Mock Get-BicepTemplate { [pscustomobject]@{ configuration_folder = $script:widgetFolder } } -ModuleName Catzc.Azure.Templates
        $descriptor = Get-BicepTemplateConfiguration sample-bicepparam alpha
        $descriptor.BicepParamFile | Should -Be (Join-Path $folder 'alpha.bicepparam')
        $descriptor.ResourceGroup | Should -BeExactly 'alpha-weu-fxo-wdgt-rg'
    }

    It 'throws on an environment not in the template list' {
        { Get-BicepTemplateConfiguration sample nonexistent } | Should -Throw
    }

    It 'reads the base slot''s config for a named slot with no file of its own (an ephemeral slot)' {
        # sample has base slots alpha/beta and no alpha-001.yml: slot 001 is ephemeral on alpha's config.
        $ephemeral = Get-BicepTemplateConfiguration sample alpha -Slot 001
        ($ephemeral | ConvertTo-Json -Depth 20) | Should -Be ((Get-BicepTemplateConfiguration sample alpha) | ConvertTo-Json -Depth 20)
    }

    It 'throws on an unknown template' {
        { Get-BicepTemplateConfiguration nonexistent alpha } | Should -Throw
    }

    It 'loads a config from the customer subfolder' {
        $configuration = Get-BicepTemplateConfiguration sample-customer alpha -Customer acme
        $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweufxoscusacst'
    }

    It 'loads the configuration-root config distinct from the customer one' {
        $shared = Get-BicepTemplateConfiguration sample-customer alpha
        $shared.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweufxoscusst'
    }

    It 'reads a customer''s base config for a named slot with no file, the customer''s own base and not the root''s' {
        # acme has alpha (base) but no alpha-002.yml: slot 002 is ephemeral on acme's alpha.
        $ephemeral = Get-BicepTemplateConfiguration sample-customer alpha -Slot 002 -Customer acme
        ($ephemeral | ConvertTo-Json -Depth 20) |
            Should -Be ((Get-BicepTemplateConfiguration sample-customer alpha -Customer acme) | ConvertTo-Json -Depth 20)
    }
}
