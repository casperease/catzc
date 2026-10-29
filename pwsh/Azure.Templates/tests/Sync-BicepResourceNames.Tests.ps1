# cspell:ignore widg gadg
Describe 'Sync-BicepResourceNames' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'templates'
        Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates { $script:root }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        $script:files = [ordered]@{
            'widget/main.bicep'              = "targetScope = 'resourceGroup'"
            'widget/options.yml'             = @(
                '# The widget fixture template.'
                'short_name: widg'
                'deployment_target: ResourceGroup'
            ) -join "`n"
            'widget/configuration/alpha.yml' = @(
                '# widget, env alpha.'
                'ResourceGroup: alpha-weu-fxo-widg-rg'
                'ParametersFile:'
                '  parameters:'
                '    # The tags every resource carries.'
                '    tags:'
                '      value:'
                '        workload: widget'
                '    logName:'
                '      value: alpha-weu-fxo-widg-ops-log'
                '    ownerRoleId:'
                '      address: global.roles.roles.owner.id'
            ) -join "`n"
            'widget/configuration/beta.yml'  = @(
                'ResourceGroup: beta-weu-fxo-widg-rg'
                'ParametersFile:'
                '  parameters:'
                '    ownerRoleId:'
                '      value: 00000000-0000-0000-0000-000000000000'
            ) -join "`n"
            'gadget/main.bicep'              = "targetScope = 'subscription'"
            'gadget/options.yml'             = @(
                'short_name: gadg'
                'deployment_target: Subscription'
            ) -join "`n"
            'gadget/configuration/alpha.yml' = @(
                'ParametersFile:'
                '  parameters:'
                '    widgetGroupName:'
                '      value: alpha-weu-fxo-widg-rg'
                '    legacyName:'
                '      value: hand-written-legacy'
                '      naming_exception: an imported name kept as it is'
                '    oddName:'
                '      value: not-a-canonical-name'
                '    gadgetSkuName:'
                '      value: Standard_LRS'
            ) -join "`n"
        }
    }

    BeforeEach {
        Remove-Item $script:root -Recurse -Force -ErrorAction Ignore
        foreach ($relative in $script:files.Keys) {
            $path = Join-Path $script:root $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            [System.IO.File]::WriteAllText($path, $script:files[$relative] + "`n")
        }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { }
    }

    It 'keeps every declared name already in the configured order, and the slot''s comments and other values' -Tag 'ADR-AZ-NAMING-DETERMINISTICNAMES' {
        Sync-BicepResourceNames -Template widget -WarningAction SilentlyContinue
        $text = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw
        $text | Should -BeLike '# widget, env alpha.*'
        $text | Should -BeLike '*    # The tags every resource carries.*'
        $slot = $text | ConvertFrom-Yaml -Ordered
        $slot.ParametersFile.parameters.tags.value.workload | Should -Be 'widget'
        $slot.ParametersFile.parameters.logName.value | Should -BeExactly 'alpha-weu-fxo-widg-ops-log'
        $slot.ParametersFile.parameters.ownerRoleId.address | Should -BeExactly 'global.roles.roles.owner.id'
    }

    It 'keeps the resource group a ResourceGroup-target slot declares as a top-level key' -Tag 'ADR-AZ-DATAMOD-DECLAREDGROUPNAME' {
        Sync-BicepResourceNames -Template widget
        $text = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw
        ($text | ConvertFrom-Yaml -Ordered).ResourceGroup | Should -BeExactly 'alpha-weu-fxo-widg-rg'
        $text.IndexOf('ResourceGroup:') | Should -BeLessThan $text.IndexOf('ParametersFile:')
    }

    It 'refuses a ResourceGroup-target slot that declares no resource group, naming the file and the key' -Tag 'ADR-AZ-DATAMOD-DECLAREDGROUPNAME' {
        $beta = Join-Path $script:root 'widget/configuration/beta.yml'
        [System.IO.File]::WriteAllText($beta, "ParametersFile:`n  parameters: {}`n")
        { Sync-BicepResourceNames -Template widget -WarningAction SilentlyContinue } | Should -Throw "*beta.yml' declares no top-level 'ResourceGroup' key*"
    }

    It 'keeps a foreign name and writes no resource group for a Subscription target' {
        Sync-BicepResourceNames -Template gadget -WarningAction SilentlyContinue
        $slot = Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $slot.ParametersFile.parameters.widgetGroupName.value | Should -BeExactly 'alpha-weu-fxo-widg-rg'
        $slot.Contains('ResourceGroup') | Should -BeFalse
    }

    It 'keeps a name with a naming_exception, and reports and keeps a name that matches no canonical form' {
        Sync-BicepResourceNames -Template gadget
        $parameters = (Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        $parameters.legacyName.value | Should -BeExactly 'hand-written-legacy'
        $parameters.legacyName.naming_exception | Should -Not -BeNullOrEmpty
        $parameters.oddName.value | Should -BeExactly 'not-a-canonical-name'
        Should -Invoke Write-Message -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Message -like "*oddName: 'not-a-canonical-name' has no single canonical match*" }
    }

    It 'leaves a parameter under a not_names suffix untouched and reports nothing for it' {
        Sync-BicepResourceNames -Template gadget
        $parameters = (Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        $parameters.gadgetSkuName.value | Should -BeExactly 'Standard_LRS'
        Should -Invoke Write-Message -ModuleName Catzc.Azure.Templates -Times 0 -Exactly -ParameterFilter { $Message -like '*gadgetSkuName*' }
    }

    It 'renders every name in the classic order once the naming overlay sets classic' -Tag 'ADR-AZ-NAMING-ORDERISVARIANT' {
        Sync-BicepResourceNames -Template widget, gadget -WarningAction SilentlyContinue
        Mock Get-Variant -ModuleName Catzc.Base.Variants -ParameterFilter { $Name -eq 'naming' } { 'classic' }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
        Sync-BicepResourceNames -Template widget, gadget -WarningAction SilentlyContinue
        $widget = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $widget.ResourceGroup | Should -BeExactly 'rg-fxo-widg-alpha-weu'
        $widget.ParametersFile.parameters.logName.value | Should -BeExactly 'log-fxo-widg-alpha-weu-ops'
        $gadget = Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $gadget.ParametersFile.parameters.widgetGroupName.value | Should -BeExactly 'rg-fxo-widg-alpha-weu'
    }

    It 'keeps the slot''s parameters in their order when it renders a name again' {
        Mock Get-Variant -ModuleName Catzc.Base.Variants -ParameterFilter { $Name -eq 'naming' } { 'classic' }
        Sync-BicepResourceNames -Template widget -WarningAction SilentlyContinue
        $alpha = (Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        @($alpha.Keys) | Should -Be @('tags', 'logName', 'ownerRoleId')
        $alpha.logName.value | Should -BeExactly 'log-fxo-widg-alpha-weu-ops'
    }

    It 'changes nothing on a second run under the same order' {
        Sync-BicepResourceNames -WarningAction SilentlyContinue
        $before = $script:files.Keys | ForEach-Object { Get-Content (Join-Path $script:root $_) -Raw }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
        Sync-BicepResourceNames -WarningAction SilentlyContinue
        $after = $script:files.Keys | ForEach-Object { Get-Content (Join-Path $script:root $_) -Raw }
        $after | Should -Be $before
    }

    It 'writes nothing under -WhatIf' {
        Sync-BicepResourceNames -WhatIf -WarningAction SilentlyContinue
        foreach ($relative in $script:files.Keys) {
            Get-Content (Join-Path $script:root $relative) -Raw | Should -BeExactly ($script:files[$relative] + "`n")
        }
    }

    It 'refuses a template that does not exist' {
        { Sync-BicepResourceNames -Template sprocket } | Should -Throw '*Template*'
    }
}
