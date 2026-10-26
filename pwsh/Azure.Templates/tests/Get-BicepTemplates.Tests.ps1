# cspell:ignore sampl deriv
Describe 'Get-BicepTemplates' -Tag 'L0', 'logic' {
    # Mocks and the cache reset run once; the cache-behavior tests invalidate bicepTemplatesCache inside their own It.
    BeforeAll {
        # Discovery reads the test fixtures, never the shipped templates, and identity resolves from the fixture config, never the shipped azure.yml.
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

    It 'discovers from the test fixtures (tests/assets/templates), not the shipped templates' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.folder | Should -BeLike '*tests*assets*templates*sample*'
        # Matched against the actual shipped root, not an 'infrastructure*templates' substring, since the fixture path legitimately contains both words.
        $shippedRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
        $sample.folder | Should -Not -BeLike "$shippedRoot*"
    }

    It 'discovers at least the sample template' {
        $templates = Get-BicepTemplates
        $templates | Should -Not -BeNullOrEmpty
        ($templates | Where-Object name -EQ 'sample') | Should -Not -BeNullOrEmpty
    }

    It 'sample has main.bicep at the expected path' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.main | Should -Exist
        $sample.main | Should -BeLike '*main.bicep'
    }

    It 'sample has a configuration_folder and at least one configuration file' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.configuration_folder | Should -Exist
        @($sample.configuration_files).Count | Should -BeGreaterThan 0
    }

    It 'sample environments include alpha and beta' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.environments | Should -Contain 'alpha'
        $sample.environments | Should -Contain 'beta'
    }

    It 'exposes the options.yml short_name override (wins over the folder-derived value)' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        # The folder 'sample' would derive 'sampl'; options.yml overrides it to 'smpl'.
        $sample.short_name | Should -Be 'smpl'
        $sample.short_name | Should -Not -Be ([Catzc.Azure.Templates.BicepShortName]::Derive('sample'))
    }

    It 'derives short_name from the folder name when the template has no options.yml' {
        $derived = (Get-BicepTemplates) | Where-Object { $_.name -eq 'derived-name' } | Select-Object -First 1
        $derived | Should -Not -BeNullOrEmpty -Because 'the derived-name fixture ships no options.yml'
        $derived.short_name | Should -Be 'deriv'
    }

    It 'exposes the subscriptions list (resolved per slot from the coordinate)' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        @($sample.subscriptions) | Should -Be @('core_lower')
    }

    It 'exposes both resolved subscriptions for a template with root + customer configs' {
        $sc = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-customer' } | Select-Object -First 1
        @($sc.subscriptions | Sort-Object) | Should -Be @('acme_lower', 'core_lower')
    }

    It 'exposes slots parsed from the config filenames (base slot = empty slot)' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $names = @($sample.slots | ForEach-Object { $_.name })
        $names | Should -Contain 'alpha'
        $names | Should -Contain 'beta'
        $alpha = $sample.slots | Where-Object { $_.name -eq 'alpha' } | Select-Object -First 1
        $alpha.environment | Should -Be 'alpha'
        $alpha.slot | Should -BeNullOrEmpty
        $alpha.subscription | Should -Be 'core_lower'
    }

    It 'sample defaults to Incremental / ResourceGroup' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.deployment_mode | Should -Be 'Incremental'
        $sample.deployment_target | Should -Be 'ResourceGroup'
    }

    It 'sample output_folder is repo-relative out/template/sample' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.output_folder | Should -BeLike '*out*template*sample*'
    }

    It 'omits prepost_module and resources for templates without them' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.prepost_module | Should -BeNullOrEmpty
        $sample.resources | Should -BeNullOrEmpty
    }

    It 'keeps Incremental / ResourceGroup defaults for a template with no options.yml' {
        $sample = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
        $sample.deployment_mode | Should -Be 'Incremental'
        $sample.deployment_target | Should -Be 'ResourceGroup'
    }

    It 'overlays deployment_target from a template options.yml' {
        $subscription = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-subscription' } |
            Select-Object -First 1
        $subscription.deployment_target | Should -Be 'Subscription'
        # Mode is not overridden in that template's options.yml, so it keeps the default.
        $subscription.deployment_mode | Should -Be 'Incremental'
    }

    Context 'per-customer configs (sample-customer)' {
        BeforeAll {
            $script:sc = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-customer' } | Select-Object -First 1
        }

        It 'exposes the distinct customers (the configuration subfolders)' {
            $sc.customers | Should -Be @('acme')
        }

        It 'tags the configuration-root slot with an empty customer and the resolved non-customer subscription' {
            $shared = $sc.slots | Where-Object { $_.name -eq 'alpha' -and $_.customer -eq '' } | Select-Object -First 1
            $shared | Should -Not -BeNullOrEmpty
            $shared.environment | Should -Be 'alpha'
            $shared.subscription | Should -Be 'core_lower'
        }

        It 'discovers the customer-subfolder slots tagged with the customer and the resolved customer subscription' {
            $acmeSlots = @($sc.slots | Where-Object { $_.customer -eq 'acme' } | ForEach-Object { $_.name } |
                    Sort-Object)
            $acmeSlots | Should -Be @('alpha', 'alpha-001')
            @($sc.slots | Where-Object { $_.customer -eq 'acme' } | ForEach-Object { $_.subscription } |
                    Select-Object -Unique) | Should -Be @('acme_lower')
        }

        It 'treats the root and customer alpha as distinct slots (same config-name, different coordinate)' {
            @($sc.slots | Where-Object { $_.name -eq 'alpha' }).Count | Should -Be 2
        }
    }

    Context 'env-class classification (environment_kind)' {
        It 'defaults to standard when options omit the bit' {
            $s = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
            $s.environment_kind | Should -Be 'standard'
        }

        It 'accepts a template that MIXES slotted and non-slotted configs (slot is per-config)' {
            # sample-customer ships acme/alpha.yml (no slot) AND acme/alpha-001.yml (slot 001).
            $sc = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-customer' } | Select-Object -First 1
            $acmeSlots = @($sc.slots | Where-Object { $_.customer -eq 'acme' } | ForEach-Object { $_.slot } |
                    Sort-Object)
            $acmeSlots | Should -Be @('', '001')
        }

        It 'reads environment_kind: subscription and accepts per-subscription envs (nsub/psub)' {
            $se = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-subenv' } | Select-Object -First 1
            $se.environment_kind | Should -Be 'subscription'
            @($se.slots | ForEach-Object { $_.environment } | Sort-Object -Unique) | Should -Be @('nsub', 'psub')
        }
    }

    Context 'bicepparam slots (ADR-AZ-DATAMOD-BICEPPARAMSLOT)' {
        BeforeAll {
            $script:fixtures = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
            # A throwaway templates root holding one copy of sample-bicepparam, changed per case.
            $script:discoverCopy = {
                param([scriptblock] $Change)
                $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
                Copy-Item (Join-Path $script:fixtures 'sample-bicepparam') (Join-Path $root 'sample-bicepparam') -Recurse
                & $Change (Join-Path $root 'sample-bicepparam')
                Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates { $root }.GetNewClosure()
                InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
                try {
                    Get-BicepTemplates
                }
                finally {
                    InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
                }
            }
        }

        It 'discovers a bicepparam slot beside a yml slot, each with its file and format' {
            $template = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample-bicepparam' } | Select-Object -First 1
            $alpha = $template.slots | Where-Object { $_.name -eq 'alpha' }
            $alpha.format | Should -BeExactly 'bicepparam'
            $alpha.file | Should -BeLike '*configuration*alpha.bicepparam'
            ($template.slots | Where-Object { $_.name -eq 'beta' }).format | Should -BeExactly 'yml'
        }

        It 'throws on a yml and a bicepparam for one coordinate, naming both' {
            { & $script:discoverCopy { param($t) Copy-Item (Join-Path $t 'configuration/beta.yml') (Join-Path $t 'configuration/alpha.yml') } } |
                Should -Throw '*has both configuration/alpha.yml and configuration/alpha.bicepparam for one coordinate*'
        }

        It 'throws on a using line that is not the template''s main.bicep, naming the file' {
            { & $script:discoverCopy { param($t) Set-Content (Join-Path $t 'configuration/alpha.bicepparam') "using '../widget.bicep'`n" } } |
                Should -Throw "*alpha.bicepparam uses '../widget.bicep', which is not the template's main.bicep*"
        }

        It 'refuses a bicepparam slot in a template with a PrePost hook, naming the template and the file' {
            { & $script:discoverCopy { param($t) Set-Content (Join-Path $t 'PrePost.psm1') '' } } |
                Should -Throw "*Template 'sample-bicepparam' has a PrePost hook, so it takes no bicepparam slot: write alpha.bicepparam as a yml slot*"
        }
    }

    Context 'session cache (docs/drs/automation/caching.md)' {
        It 'caches across calls — returns the same object' {
            $first = Get-BicepTemplates
            $second = Get-BicepTemplates
            [object]::ReferenceEquals($first, $second) |
                Should -BeTrue -Because 'filesystem-derived descriptor is memoized for the session'
        }

        It 're-derives after the cache is reset (the importer-boundary invalidation)' {
            $first = Get-BicepTemplates
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
            $second = Get-BicepTemplates
            [object]::ReferenceEquals($first, $second) |
                Should -BeFalse -Because 'a reset cache rebuilds a fresh result'
            @($second | ForEach-Object { $_.name } | Sort-Object) |
                Should -Be @($first | ForEach-Object { $_.name } |
                        Sort-Object) -Because 'same on-disk inputs yield the same templates'
        }
    }
}
