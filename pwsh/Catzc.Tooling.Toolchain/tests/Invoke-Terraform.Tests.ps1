<#
---
catzc:
  immutable:
    with_body_sha: "1b9a11fee0ea"
  edges:
    code: pwsh/Catzc.Tooling.Toolchain/Invoke-Terraform.ps1
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
