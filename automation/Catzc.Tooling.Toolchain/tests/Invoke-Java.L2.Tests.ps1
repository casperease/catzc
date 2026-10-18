Describe 'Invoke-Java' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'java'
    }

    It 'outputs version info to stderr' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_java_missing'; return
        }
        $result = Invoke-Java '-version' -PassThru -Silent -NoAssert
        $result.Errors | Should -Match 'version'
    }
}
