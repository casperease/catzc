Describe 'Invoke-AzCli' -Tag 'L2', 'logic' {
    It 'returns version as JSON with accessible properties' {
        # Gate on presence, not the locked version: this thread proves Invoke-AzCli shells out to a working
        # `az` — it does not assert tools.yml's version lock, so a functional-but-off-version az must still run
        # (matching the Build-Bicep L2 skeleton). The skip key is the constrained `tool_az_missing` grammar.
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'; return
        }
        $result = Invoke-AzCli 'version --output json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $version = $result.Output | ConvertFrom-Json
        $version.'azure-cli' | Should -Not -BeNullOrEmpty
    }
}
