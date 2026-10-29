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
                'names:'
                '  logName: { type: log, role: ops }'
                '  storageName: { type: st }'
                '# The enforcement fact every slot takes.'
                'facts:'
                '  enforcePolicy: policy_enforcement'
                'addresses:'
                '  ownerRoleId: global.roles.roles.owner.id'
            ) -join "`n"
            'widget/configuration/alpha.yml' = @(
                '# widget, env alpha.'
                'ParametersFile:'
                '  parameters:'
                '    # The tags every resource carries.'
                '    tags:'
                '      value:'
                '        workload: widget'
            ) -join "`n"
            'widget/configuration/beta.yml'  = @(
                'ParametersFile:'
                '  parameters:'
                '    ownerRoleId:'
                '      value: 00000000-0000-0000-0000-000000000000'
            ) -join "`n"
            'gadget/main.bicep'              = "targetScope = 'subscription'"
            'gadget/options.yml'             = @(
                'short_name: gadg'
                'deployment_target: Subscription'
                'names:'
                '  widgetGroupName: { type: rg, template: widget }'
            ) -join "`n"
            'gadget/configuration/alpha.yml' = @(
                'ParametersFile:'
                '  parameters:'
                '    legacyName:'
                '      value: hand-written-legacy'
                '      naming_exception: an imported name kept as it is'
                '    oddName:'
                '      value: not-a-canonical-name'
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

    It 'writes each slot''s derived names under their parameters and keeps its comments' -Tag 'ADR-AZ-NAMING-DETERMINISTICNAMES' {
        Sync-BicepResourceNames -Template widget -WarningAction SilentlyContinue
        $text = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw
        $text | Should -BeLike '# widget, env alpha.*'
        $text | Should -BeLike '*    # The tags every resource carries.*'
        $slot = $text | ConvertFrom-Yaml -Ordered
        $slot.ParametersFile.parameters.tags.value.workload | Should -Be 'widget'
        $slot.ParametersFile.parameters.logName.value | Should -BeExactly 'alpha-weu-fxo-widg-ops-log'
        $slot.ParametersFile.parameters.storageName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Type st)
    }

    It 'declares the resource group of a ResourceGroup-target slot as a top-level key' {
        Sync-BicepResourceNames -Template widget
        $text = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw
        ($text | ConvertFrom-Yaml -Ordered).ResourceGroup | Should -BeExactly 'alpha-weu-fxo-widg-rg'
        $text.IndexOf('ResourceGroup:') | Should -BeLessThan $text.IndexOf('ParametersFile:')
    }

    It 'moves the facts and addresses of the options into each slot, and a slot that sets the parameter keeps its own' -Tag 'ADR-AZ-DATAMOD-VALUEBYADDRESS' {
        Sync-BicepResourceNames -Template widget
        $alpha = (Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        $alpha.enforcePolicy.fact | Should -BeExactly 'policy_enforcement'
        $alpha.ownerRoleId.address | Should -BeExactly 'global.roles.roles.owner.id'
        $beta = (Get-Content (Join-Path $script:root 'widget/configuration/beta.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        $beta.ownerRoleId.value | Should -BeExactly '00000000-0000-0000-0000-000000000000'
        $beta.ownerRoleId.Contains('address') | Should -BeFalse
    }

    It 'removes names, facts and addresses from the options with their comments and keeps the rest' {
        Sync-BicepResourceNames -Template widget
        $options = Get-Content (Join-Path $script:root 'widget/options.yml') -Raw
        $options -replace "`r", '' | Should -BeExactly "# The widget fixture template.`nshort_name: widg`ndeployment_target: ResourceGroup`n"
    }

    It 'writes a foreign name under its owner''s short_name and no resource group for a Subscription target' {
        Sync-BicepResourceNames -Template gadget -WarningAction SilentlyContinue
        $slot = Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $slot.ParametersFile.parameters.widgetGroupName.value | Should -BeExactly 'alpha-weu-fxo-widg-rg'
        $slot.Contains('ResourceGroup') | Should -BeFalse
    }

    It 'keeps a name with a naming_exception, and warns and keeps a name that matches no canonical form' {
        Sync-BicepResourceNames -Template gadget -WarningVariable warnings -WarningAction SilentlyContinue
        $parameters = (Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered).ParametersFile.parameters
        $parameters.legacyName.value | Should -BeExactly 'hand-written-legacy'
        $parameters.legacyName.naming_exception | Should -Not -BeNullOrEmpty
        $parameters.oddName.value | Should -BeExactly 'not-a-canonical-name'
        @($warnings | ForEach-Object Message) | Should -HaveCount 1
        "$($warnings[0])" | Should -BeLike "*oddName: 'not-a-canonical-name' has no single canonical match*"
    }

    It 'renders every name in the classic order once the naming overlay sets classic' -Tag 'ADR-AZ-NAMING-ORDERISVARIANT' {
        Sync-BicepResourceNames -Template widget, gadget -WarningAction SilentlyContinue
        Mock Get-Variant -ModuleName Catzc.Base.Variants -ParameterFilter { $Name -eq 'naming' } { 'classic' }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
        Sync-BicepResourceNames -Template widget, gadget -WarningAction SilentlyContinue
        $widget = Get-Content (Join-Path $script:root 'widget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $widget.ResourceGroup | Should -BeExactly 'rg-fxo-widg-alpha-weu'
        $widget.ParametersFile.parameters.logName.value | Should -BeExactly 'log-fxo-widg-alpha-weu-ops'
        $widget.ParametersFile.parameters.storageName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Type st)
        $gadget = Get-Content (Join-Path $script:root 'gadget/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
        $gadget.ParametersFile.parameters.widgetGroupName.value | Should -BeExactly 'rg-fxo-widg-alpha-weu'
    }

    It 'changes nothing on a second run under the same order' {
        Sync-BicepResourceNames -WarningAction SilentlyContinue
        $before = Get-ChildItem $script:root -Recurse -File | ForEach-Object { Get-Content $_.FullName -Raw }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
        Sync-BicepResourceNames -WarningAction SilentlyContinue
        $after = Get-ChildItem $script:root -Recurse -File | ForEach-Object { Get-Content $_.FullName -Raw }
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
