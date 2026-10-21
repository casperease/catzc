<#
---
catzc:
  immutable:
    with_body_sha: "7935d4874195"
  edges:
    code: pwsh/Catzc.Azure.Cli/Invoke-AzCli.ps1
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
