<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/tests/Invoke-AzCli.L2.Tests.ps1
    folder: tests
    name: invoke-az-cli-l2-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-cli/tests/Invoke-AzCli.L2.Tests.ps1.md
---
#>

Describe 'Invoke-AzCli' -Tag 'L2', 'logic' {
    It 'returns version as JSON with accessible properties' {
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'; return
        }
        $result = Invoke-AzCli 'version --output json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.'azure-cli' | Should -Not -BeNullOrEmpty
    }
}
