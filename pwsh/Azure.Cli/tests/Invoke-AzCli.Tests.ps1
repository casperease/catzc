Describe 'Invoke-AzCli' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-AzCli 'account show' -DryRun | Should -Be 'az account show'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-AzCli 'group list --output table' -DryRun | Should -Be 'az group list --output table'
    }

    Context 'restoring the dynamic-install variable' {
        BeforeEach {
            Mock Assert-Tool { } -ModuleName Catzc.Azure.Cli
            Mock Invoke-Executable { } -ModuleName Catzc.Azure.Cli
            $script:savedDynamic = [Environment]::GetEnvironmentVariable('AZURE_EXTENSION_USE_DYNAMIC_INSTALL', 'Process')
        }

        AfterEach {
            if ($null -eq $script:savedDynamic) {
                Remove-Item -LiteralPath 'Env:AZURE_EXTENSION_USE_DYNAMIC_INSTALL' -ErrorAction Ignore
            }
            else {
                [Environment]::SetEnvironmentVariable('AZURE_EXTENSION_USE_DYNAMIC_INSTALL', $script:savedDynamic, 'Process')
            }
        }

        It 'leaves the variable absent after a run when it was unset before' {
            Remove-Item -LiteralPath 'Env:AZURE_EXTENSION_USE_DYNAMIC_INSTALL' -ErrorAction Ignore
            Invoke-AzCli 'account show'
            Test-Path -LiteralPath 'Env:AZURE_EXTENSION_USE_DYNAMIC_INSTALL' | Should -BeFalse
        }

        It 'restores the prior value after a run when it was set before' {
            [Environment]::SetEnvironmentVariable('AZURE_EXTENSION_USE_DYNAMIC_INSTALL', 'widget', 'Process')
            Invoke-AzCli 'account show'
            [Environment]::GetEnvironmentVariable('AZURE_EXTENSION_USE_DYNAMIC_INSTALL', 'Process') | Should -Be 'widget'
        }
    }
}
