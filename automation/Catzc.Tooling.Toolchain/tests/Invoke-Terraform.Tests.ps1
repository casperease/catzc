<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.Tests.ps1
    folder: tests
    name: invoke-terraform-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
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
