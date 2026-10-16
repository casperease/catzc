<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Invoke-Terraform' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Terraform 'plan' -DryRun | Should -Be 'terraform plan'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-Terraform 'apply -auto-approve' -DryRun | Should -Be 'terraform apply -auto-approve'
    }
}
