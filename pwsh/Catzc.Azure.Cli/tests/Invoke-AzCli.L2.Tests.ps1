<#
---
catzc:
  immutable:
    with_body_sha: ef845f26a88b
  edges:
    docs: "[Invoke-AzCli.L2.Tests.ps1.md](docs/references/pwsh/catzc-azure-cli/tests/Invoke-AzCli.L2.Tests.ps1.md)"
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
