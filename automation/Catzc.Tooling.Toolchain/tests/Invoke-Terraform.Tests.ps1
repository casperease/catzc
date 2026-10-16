<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    relatives:
      source: automation/Catzc.Tooling.Toolchain/Invoke-Terraform.ps1
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
