Describe 'Invoke-AzCli' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'az_cli'
    }

    It 'returns version as JSON with accessible properties' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_az_missing'; return
        }
        $result = Invoke-AzCli 'version --output json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.'azure-cli' | Should -Not -BeNullOrEmpty
    }
}
