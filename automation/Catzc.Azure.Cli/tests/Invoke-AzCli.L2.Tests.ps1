<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/tests/Invoke-AzCli.L2.Tests.ps1
    kind: pester-test
---
#>

Describe 'Invoke-AzCli' -Tag 'L2', 'logic' {
    It 'returns version as JSON with accessible properties' {
        # Gate on presence, not the locked version: this thread proves Invoke-AzCli shells out to a working `az` — it...
        # [comment:1](/docs/references/automation/catzc-azure-cli/tests/Invoke-AzCli.L2.Tests.ps1.md#comment1)
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'; return
        }
        $result = Invoke-AzCli 'version --output json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.'azure-cli' | Should -Not -BeNullOrEmpty
    }
}
