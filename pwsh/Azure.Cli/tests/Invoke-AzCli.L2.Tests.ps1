Describe 'Invoke-AzCli' -Tag 'L2', 'logic' {
    It 'returns version as JSON with accessible properties' {
        # Gated on presence, not the pinned version: this proves a working az is reached, not that its version matches.
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'; return
        }
        $result = Invoke-AzCli 'version --output json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.'azure-cli' | Should -Not -BeNullOrEmpty
    }
}
