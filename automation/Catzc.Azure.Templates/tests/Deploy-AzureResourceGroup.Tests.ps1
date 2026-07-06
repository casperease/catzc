# cspell:ignore nproperties
Describe 'Deploy-AzureResourceGroup' -Tag 'L0', 'logic' {
    BeforeAll {
        # The caller resolves the subscription + region and passes them in; this function never
        # re-resolves from azure.yml (so the RG always lands in the deployment's subscription).
        $script:subId = '50a0ed00-de00-50b0-0000-000000000000'
    }

    Context 'when the resource group already exists' {
        BeforeEach {
            Mock Invoke-AzCli {
                if ($Arguments -match '^group exists') {
                    [pscustomobject]@{ Output = 'true'; ExitCode = 0 }
                }
                else {
                    throw "Unexpected az call in this context: $Arguments"
                }
            } -ModuleName Catzc.Azure.Templates
        }

        It 'returns provisioning_state = Skipped without calling group create' {
            $r = Deploy-AzureResourceGroup -SubscriptionId $script:subId -Region westeurope -ResourceGroup rg-sample-alpha
            $r.provisioning_state | Should -Be 'Skipped'
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter { $Arguments -match '^group create' } -Times 0
        }
    }

    Context 'when the resource group does not exist' {
        BeforeEach {
            Mock Invoke-AzCli {
                if ($Arguments -match '^group exists') {
                    [pscustomobject]@{ Output = 'false'; ExitCode = 0 }
                }
                elseif ($Arguments -match '^group create') {
                    [pscustomobject]@{
                        Output   = "name: rg-sample-alpha`nproperties:`n  provisioningState: Succeeded"
                        ExitCode = 0
                    }
                }
                else {
                    throw "Unexpected az call: $Arguments"
                }
            } -ModuleName Catzc.Azure.Templates
        }

        It 'returns Succeeded and calls group create with the given region + subscription' {
            $r = Deploy-AzureResourceGroup -SubscriptionId $script:subId -Region westeurope -ResourceGroup rg-sample-alpha
            $r.provisioning_state | Should -Be 'Succeeded'
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match '^group create' -and
                $Arguments -match 'westeurope' -and
                $Arguments -match '--subscription 50a0ed00-de00-50b0-0000-000000000000'
            }
        }

        It 'throws when provisioningState comes back not-Succeeded' {
            Mock Invoke-AzCli {
                if ($Arguments -match '^group exists') {
                    [pscustomobject]@{ Output = 'false'; ExitCode = 0 }
                }
                else {
                    [pscustomobject]@{
                        Output   = "properties:`n  provisioningState: Failed"
                        ExitCode = 0
                    }
                }
            } -ModuleName Catzc.Azure.Templates

            { Deploy-AzureResourceGroup -SubscriptionId $script:subId -Region westeurope -ResourceGroup rg-sample-alpha } | Should -Throw '*Failed to create*'
        }

        It '-DryRun returns provisioning_state = DryRun without calling group create' {
            $r = Deploy-AzureResourceGroup -SubscriptionId $script:subId -Region westeurope -ResourceGroup rg-sample-alpha -DryRun
            $r.provisioning_state | Should -Be 'DryRun'
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter { $Arguments -match '^group create' } -Times 0
        }
    }
}
