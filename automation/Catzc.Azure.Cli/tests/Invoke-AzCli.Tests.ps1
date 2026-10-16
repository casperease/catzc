<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/tests/Invoke-AzCli.Tests.ps1
    folder: tests
    name: invoke-az-cli-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-AzCli' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-AzCli 'account show' -DryRun | Should -Be 'az account show'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-AzCli 'group list --output table' -DryRun | Should -Be 'az group list --output table'
    }
}
