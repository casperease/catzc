Describe 'Invoke-BreakGlassRotation' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:calls = [System.Collections.Generic.List[string]]::new()
        $script:messages = [System.Collections.Generic.List[string]]::new()
        Mock Get-BicepTemplate -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{
                slots = @(
                    [pscustomobject]@{ name = 'widget'; environment = 'widget'; slot = ''; customer = '' }
                    [pscustomobject]@{ name = 'sprocket/widget'; environment = 'widget'; slot = ''; customer = 'sprocket' }
                    [pscustomobject]@{ name = 'cog/widget'; environment = 'widget'; slot = ''; customer = 'cog' }
                    [pscustomobject]@{ name = 'gizmo'; environment = 'gizmo'; slot = ''; customer = '' }
                )
            }
        }
        # The slot of cog has no Key Vault reference: a slot without a break-glass password.
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot -ParameterFilter { $Customer -eq 'cog' } {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ administratorLoginPassword = [ordered]@{ value = 'not-a-reference' } } } }
        }
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot {
            [ordered]@{
                ParametersFile = [ordered]@{
                    parameters = [ordered]@{
                        administratorLoginPassword = [ordered]@{
                            reference = [ordered]@{
                                keyVault   = [ordered]@{ id = '/subscriptions/0/resourceGroups/widget-rg/providers/Microsoft.KeyVault/vaults/widget-kv' }
                                secretName = 'gadget-secret'
                            }
                        }
                    }
                }
            }
        }
        Mock Get-BicepSlotResourceGroup -ModuleName Catzc.Azure.Templates -RemoveParameterValidation TemplateDescriptor, Environment { 'gadget-rg' }
        Mock Get-BicepResourceName -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot { 'gadget-sql' }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { $script:messages.Add("$Message") }
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates {
            $script:calls.Add($Arguments)
            [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' }
        }
        # The secret the vault command would read, captured before the command deletes its file.
        $script:written = $null
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter { $Arguments -like 'keyvault secret set*' } {
            $script:calls.Add($Arguments)
            $script:written = [System.IO.File]::ReadAllText(([regex]::Match($Arguments, '--file "([^"]+)"')).Groups[1].Value)
            [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' }
        }
    }

    It 'rotates every slot of the environment that has a Key Vault reference, one after another, and reports each' {
        Invoke-BreakGlassRotation widget
        $calls.Count | Should -Be 4
        $calls[0] | Should -BeLike 'sql server update*'
        $calls[1] | Should -BeLike 'keyvault secret set*'
        $calls[2] | Should -BeLike 'sql server update*'
        $calls[3] | Should -BeLike 'keyvault secret set*'
        @($messages | Where-Object { $_ -like 'Rotated the break-glass password*' }).Count | Should -Be 2
        Should -Invoke Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -Times 0 -ParameterFilter { $Environment -eq 'gizmo' }
    }

    It 'narrows to one customer''s slot when one is given' {
        Invoke-BreakGlassRotation widget -Customer sprocket
        $calls.Count | Should -Be 2
        $messages | Should -Match 'slot sprocket/widget'
    }

    It 'sets the new password on the server first, then writes the same password to the vault' {
        Invoke-BreakGlassRotation widget -Customer sprocket
        $calls.Count | Should -Be 2
        $calls[0] | Should -BeLike 'sql server update --resource-group gadget-rg --name gadget-sql --admin-password *'
        $calls[1] | Should -BeLike 'keyvault secret set --vault-name widget-kv --name gadget-secret --file *'
        $password = ([regex]::Match($calls[0], '--admin-password "([^"]+)"')).Groups[1].Value
        $password.Length | Should -Be 32
        $written | Should -BeExactly $password
    }

    It 'never puts the password in a message, on the vault command, or in a file left behind' {
        Invoke-BreakGlassRotation widget -Customer sprocket
        $password = ([regex]::Match($calls[0], '--admin-password "([^"]+)"')).Groups[1].Value
        $calls[1] | Should -Not -Match ([regex]::Escape($password))
        foreach ($message in $messages) {
            $message | Should -Not -Match ([regex]::Escape($password))
        }
        [System.IO.File]::Exists(([regex]::Match($calls[1], '--file "([^"]+)"')).Groups[1].Value) | Should -BeFalse
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 2 -Exactly -ParameterFilter { $Silent }
    }

    It 'leaves the vault alone and names no password when the server update fails' {
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter { $Arguments -like 'sql server update*' } {
            $script:calls.Add($Arguments)
            [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'denied' }
        }
        $thrown = { Invoke-BreakGlassRotation widget -Customer sprocket } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike '*keep the old one*'
        $password = ([regex]::Match($calls[0], '--admin-password "([^"]+)"')).Groups[1].Value
        $thrown.Exception.Message | Should -Not -Match ([regex]::Escape($password))
        $calls.Count | Should -Be 1
    }

    It 'calls nothing on a dry run' {
        Invoke-BreakGlassRotation widget -DryRun
        $calls.Count | Should -Be 0
        @($messages | Where-Object { $_ -like 'Would set a new break-glass password on SQL server gadget-sql*' }).Count | Should -Be 2
    }

    It 'refuses when no slot of the selection has a Key Vault reference for the password' {
        { Invoke-BreakGlassRotation widget -Customer cog } | Should -Throw -ExpectedMessage '*No expedition slot*'
        $calls.Count | Should -Be 0
    }
}

Describe 'New-BreakGlassPassword' -Tag 'L0', 'logic' {
    It 'holds every class SQL requires, at the asked length, and no quote, backslash, space or dollar' {
        InModuleScope Catzc.Azure.Templates {
            foreach ($length in 16, 32, 64) {
                $password = New-BreakGlassPassword -Length $length
                $password.Length | Should -Be $length
                $password | Should -MatchExactly '[A-Z]'
                $password | Should -MatchExactly '[a-z]'
                $password | Should -Match '[0-9]'
                $password | Should -Match '[-_.~!@#%^+=]'
                $password | Should -Not -Match '["''`\\ $]'
            }
        }
    }
}

Describe 'The break-glass rotation pipeline' -Tag 'L1', 'integrity' {
    It 'runs the rotation on a monthly schedule, signed in through the deploy service connection' {
        $pipeline = Get-Content -Raw (Join-Path (Get-RepositoryRoot) '.ado/pipelines/cron-break-glass-rotation.yaml') | ConvertFrom-Yaml
        $pipeline.trigger | Should -Be 'none'
        $pipeline.pr | Should -Be 'none'
        @($pipeline.schedules).Count | Should -BeGreaterThan 0
        $schedule = $pipeline.schedules | Select-Object -First 1
        $schedule.cron | Should -Match '^\S+ \S+ \S+ \* \*$|^\S+ \S+ 1 \* \*$'
        $schedule.always | Should -BeTrue
        $text = Get-Content -Raw (Join-Path (Get-RepositoryRoot) '.ado/pipelines/cron-break-glass-rotation.yaml')
        $text | Should -Match 'Invoke-BreakGlassRotation'
        $text | Should -Match 'Mode: azcli'
    }
}
