# cspell:ignore toolong gmweufxosmplst alweufxosmplst
Describe 'Set-BicepTemplateConfiguration' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureTemplates = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'

        # Get-BicepTemplatesRoot reads the current $script:templatesRoot at call time, so each context just repoints that variable.
        Mock Get-BicepTemplatesRoot { $script:templatesRoot } -ModuleName Catzc.Azure.Templates
        # The templates root is a copy outside the checkout, so the generated head reads no file as tracked.
        Import-InternalModule TestKit
        Set-GitTrackedPathMock
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'validation and read-only' {
        # None of these write to the tree, so one copy + one discovery is shared across all of them.
        BeforeAll {
            # A fresh unique root is never re-deleted mid-run, so it cannot race a scanner holding a just-copied file open; Copy-Directory is ~15x faster than Copy-Item.
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Cleared once, then warmed here: the -Template ValidateScript runs discovery at binding, which is ~6x inflated under Mock interception.
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
            Get-BicepTemplates | Out-Null
        }

        It 'DryRun returns the planned content without writing' {
            $result = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'z' } -DryRun
            $result.Written | Should -BeFalse
            $result.Content | Should -Match 'z'
            $result.Path | Should -Not -Exist
        }

        It 'throws on an undefined environment' {
            { Set-BicepTemplateConfiguration sample zzz -Parameters @{ a = 'b' } } |
                Should -Throw '*not defined in azure.yml*'
        }

        It 'throws on empty parameters' {
            { Set-BicepTemplateConfiguration sample alpha -Parameters @{} } | Should -Throw '*cannot be empty*'
        }

        It 'throws on an invalid slot' {
            { Set-BicepTemplateConfiguration sample alpha -Slot 'toolong' -Parameters @{ a = 'b' } } |
                Should -Throw '*1-3 lowercase*'
        }

        It 'throws when -Customer is not a customer key in the catalogue' {
            { Set-BicepTemplateConfiguration sample-customer alpha -Customer zzz -Parameters @{ a = 'b' } } |
                Should -Throw '*not a customer key*'
        }

        It 'throws when the coordinate resolves to no subscription' {
            # globex is a defined customer but has no subscription in the fixture azure.yml.
            { Set-BicepTemplateConfiguration sample-customer alpha -Customer globex -Parameters @{ a = 'b' } } |
                Should -Throw '*cannot be resolved*'
        }
    }

    Context 'writes' {
        # Each test writes a distinct config path, so one shared copy and one discovery keep the cache warm without interference or order dependence.
        BeforeAll {
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Cleared once, then warmed here; writes never invalidate the session-scoped templates cache, so one warm-up serves every test.
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
            Get-BicepTemplates | Out-Null
        }

        It 'creates a new configuration-root config file for a new environment' {
            # gamma resolves to core_upper (the one non-customer subscription serving it).
            $result = Set-BicepTemplateConfiguration sample gamma -Parameters @{ storageAccountName = 'gmweufxosmplst' }
            $result.Written | Should -BeTrue
            $result.Path | Should -Exist
            $result.Path | Should -Match 'configuration[\\/]gamma\.yml'
            $configuration = Get-Content $result.Path -Raw | ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'gmweufxosmplst'
        }

        It 'throws on a bicepparam slot, naming its file, and writes nothing' {
            $file = Join-Path $script:templatesRoot 'sample-bicepparam/configuration/alpha.bicepparam'
            $sibling = Join-Path $script:templatesRoot 'sample-bicepparam/configuration/alpha.yml'
            $before = [System.IO.File]::ReadAllText($file)
            $siblingBefore = [System.IO.File]::ReadAllText($sibling)
            { Set-BicepTemplateConfiguration sample-bicepparam alpha -Parameters @{ storageAccountName = 'widget' } } |
                Should -Throw "*slot 'alpha' is a bicepparam slot*alpha.bicepparam*edited by hand*"
            [System.IO.File]::ReadAllText($file) | Should -BeExactly $before
            [System.IO.File]::ReadAllText($sibling) | Should -BeExactly $siblingBefore
        }

        It 'merges into an existing config, preserving other parameters' {
            Set-BicepTemplateConfiguration sample alpha -Parameters @{ keyVaultName = 'al-weu-kv' } | Out-Null
            $configuration = Get-Content (Join-Path $script:templatesRoot 'sample/configuration/alpha.yml') -Raw |
                ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.keyVaultName.value | Should -Be 'al-weu-kv'
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweufxosmplst'
        }

        It 'writes the generated head with the one warning, and no generator: the writer is derived on demand' {
            $result = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'x' } -DryRun
            $result.Content |
                Should -BeLike "# ---`n# catzc:`n#   immutable:`n#     warning: `"$((Get-Config -Config generated-head).warning)`"`n*"
            $result.Content | Should -Not -BeLike '*generator:*'
            $result.Content | Should -Not -BeLike '*Generated by*'
        }

        It 'is idempotent — two identical writes leave identical content' {
            # delta (not gamma) so this shares the BeforeAll tree with the 'creates' test without colliding.
            $first = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'x' }
            $second = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'x' }
            $second.Content | Should -Be $first.Content
        }

        It 'writes under the customer subfolder when -Customer is given' {
            $result = Set-BicepTemplateConfiguration sample-customer alpha -Customer acme -Parameters @{ storageAccountName = 'y' }
            $result.Path | Should -Match 'configuration[\\/]acme[\\/]alpha\.yml'
            $result.Path | Should -Exist
        }
    }
}
