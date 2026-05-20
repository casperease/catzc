Describe 'Invoke-Pip' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'python'
    }

    It 'reports pip version' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_python_missing'; return
        }
        $result = Invoke-Pip '--version' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $result.Output | Should -Match 'pip'
    }

    It 'lists packages as JSON with accessible properties' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_python_missing'; return
        }
        $result = Invoke-Pip 'list --format json' -PassThru -Silent
        $result.ExitCode | Should -Be 0
        $packages = $result.Output | ConvertFrom-Json
        $packages.Count | Should -BeGreaterThan 0
        $packages[0].name | Should -Not -BeNullOrEmpty
    }
}
