Describe 'Invoke-Dotnet' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'dotnet'
    }

    It 'lists installed SDKs as multi-line output' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'; return
        }
        $result = Invoke-Dotnet '--list-sdks' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $result.Output | Should -Not -BeNullOrEmpty
        $result.Raw.Count | Should -BeGreaterOrEqual 1
    }
}
