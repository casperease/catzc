<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.L2.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
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
