<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.L2.Tests.ps1
    folder: tests
    name: invoke-terraform-l2-tests
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

Describe 'Invoke-Terraform' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'terraform'
    }

    It 'reports version as JSON with accessible properties' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_terraform_missing'; return
        }
        $result = Invoke-Terraform 'version -json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.terraform_version | Should -Match '\d+\.\d+'
    }
}
