Describe 'Set-AnomalyAlertRecipientSecret' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:calls = [System.Collections.Generic.List[string]]::new()
        $script:messages = [System.Collections.Generic.List[string]]::new()
        $script:written = $null
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            [pscustomobject]@{ environments = @{ widget = @{} } }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'anomaly-alert' } {
            [Catzc.Azure.Templates.AnomalyAlertConfig]::new([ordered]@{ configuration_template = 'sample'; vault_template = 'gadget' })
        }
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Azure.Templates { $false }
        Mock Get-AzCliSessionSubscription -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{ id = '00000000-0000-0000-0000-00000000000a'; name = 'widget_sub'; customer = 'sprocket' }
        }
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot {
            [ordered]@{
                ParametersFile = [ordered]@{
                    parameters = [ordered]@{
                        anomalyAlertRecipients = [ordered]@{
                            reference = [ordered]@{
                                keyVault   = [ordered]@{ id = '/subscriptions/0/resourceGroups/widget-rg/providers/Microsoft.KeyVault/vaults/widget-kv' }
                                secretName = 'gadget-recipients'
                            }
                        }
                    }
                }
            }
        }
        Mock Get-BicepResourceName -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot { 'widget-kv' }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { $script:messages.Add("$Message") }
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates {
            $script:calls.Add($Arguments)
            $script:written = [System.IO.File]::ReadAllText(([regex]::Match($Arguments, '--file "([^"]+)"')).Groups[1].Value)
            [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' }
        }
    }

    It 'writes the trimmed recipients to the referenced secret in foundation''s vault, through a file left behind nowhere' {
        Set-AnomalyAlertRecipientSecret widget -Value ' a@widget.example , b@widget.example'
        $calls.Count | Should -Be 1
        $calls[0] | Should -BeLike 'keyvault secret set --vault-name widget-kv --name gadget-recipients --file *'
        $written | Should -BeExactly 'a@widget.example,b@widget.example'
        [System.IO.File]::Exists(([regex]::Match($calls[0], '--file "([^"]+)"')).Groups[1].Value) | Should -BeFalse
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Silent }
        $messages | Should -Match 'Wrote 2 anomaly alert recipients to secret gadget-recipients in vault widget-kv'
    }

    It 'names the vault by the namer, for the configured templates, the environment and the session''s customer' {
        Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example'
        Should -Invoke Get-BicepResourceName -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter {
            $Template -eq 'gadget' -and $Environment -eq 'widget' -and $Type -eq 'kv' -and $Customer -eq 'sprocket'
        }
        Should -Invoke Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter {
            $Template -eq 'sample' -and $Customer -eq 'sprocket'
        }
    }

    It 'calls nothing on a dry run and never names a recipient' {
        Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' -DryRun
        $calls.Count | Should -Be 0
        $messages | Should -Match 'Would write 1 anomaly alert recipients'
        $messages | Should -Not -Match 'a@widget.example'
    }

    It 'refuses a value that is not comma-separated email addresses, before any call' {
        { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example,,gadget' } | Should -Throw -ExpectedMessage '*2 of 3 entries*'
        $calls.Count | Should -Be 0
        Should -Invoke Get-AzCliSessionSubscription -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 'refuses when the reference names another vault than the namer' {
        Mock Get-BicepResourceName -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot { 'gadget-kv' }
        { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' } | Should -Throw -ExpectedMessage "*references vault 'widget-kv'*'gadget-kv'*"
        $calls.Count | Should -Be 0
    }

    It 'refuses when discovery''s configuration has no reference for the recipients' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Template, Environment, Customer, Slot {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ anomalyAlertRecipients = [ordered]@{ value = 'gadget' } } } }
        }
        { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' } | Should -Throw -ExpectedMessage '*no Key Vault reference*'
        $calls.Count | Should -Be 0
    }

    It 'requires -SubscriptionIdAssertIs in a pipeline' {
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Azure.Templates { $true }
        { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' } | Should -Throw -ExpectedMessage '*requires -SubscriptionIdAssertIs*'
    }

    It 'refuses a session on another subscription than the asserted one' {
        { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' -SubscriptionIdAssertIs '00000000-0000-0000-0000-00000000000b' } |
            Should -Throw -ExpectedMessage '*-SubscriptionIdAssertIs failed*'
        $calls.Count | Should -Be 0
    }

    It 'seeds on the asserted subscription' {
        Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' -SubscriptionIdAssertIs '00000000-0000-0000-0000-00000000000a'
        $calls.Count | Should -Be 1
    }

    It 'reports the az exit code and keeps the value out of the error when the write fails' {
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates { [pscustomobject]@{ ExitCode = 3; Output = ''; Errors = 'denied' } }
        $thrown = { Set-AnomalyAlertRecipientSecret widget -Value 'a@widget.example' } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike '*az exit code 3*'
        $thrown.Exception.Message | Should -Not -Match 'a@widget.example'
    }
}

Describe 'Set-KeyVaultSecretValue' -Tag 'L0', 'logic' {
    It 'writes the value through a UTF-8 file it deletes, silently, and returns the az exit code' {
        $script:seen = $null
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates {
            $path = ([regex]::Match($Arguments, '--file "([^"]+)"')).Groups[1].Value
            $script:seen = [pscustomobject]@{ Arguments = $Arguments; Text = [System.IO.File]::ReadAllText($path); Path = $path }
            [pscustomobject]@{ ExitCode = 5; Output = ''; Errors = '' }
        }
        $exitCode = InModuleScope Catzc.Azure.Templates { Set-KeyVaultSecretValue -Vault widget-kv -Name gadget -Value 'sprocket' }
        $exitCode | Should -Be 5
        $seen.Arguments | Should -BeLike 'keyvault secret set --vault-name widget-kv --name gadget --file * --encoding utf-8 --output none'
        $seen.Arguments | Should -Not -Match 'sprocket'
        $seen.Text | Should -BeExactly 'sprocket'
        [System.IO.File]::Exists($seen.Path) | Should -BeFalse
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Silent -and $NoAssert -and $PassThru }
    }
}

Describe 'The anomaly alert recipients seed in the deploy pipelines' -Tag 'L1', 'integrity' {
    It 'seeds the secret from the AnomalyAlertRecipients variable in every discovery job, before its what-if' {
        $text = Get-Content -Raw (Join-Path (Get-RepositoryRoot) '.ado/pipelines/stages/deploy-unit.yaml')
        $discovery = $text.Substring($text.IndexOf('stage: Deploy_Discovery'))
        $discovery = $discovery.Substring(0, $discovery.IndexOf('template: /.ado/pipelines/stages/deploy-expedition.yaml'))
        $seed = $discovery.IndexOf('Set-AnomalyAlertRecipientSecret')
        $seed | Should -BeGreaterThan 0
        $seed | Should -BeLessThan $discovery.IndexOf('-Template discovery')
        $discovery | Should -Match 'Set-AnomalyAlertRecipientSecret -Environment \$\{\{ d\.env \}\} -SubscriptionIdAssertIs'
        $discovery | Should -Match '-Value "\$\(AnomalyAlertRecipients\)"'
    }
}
