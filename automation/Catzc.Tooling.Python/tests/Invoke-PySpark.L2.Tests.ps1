Describe 'Invoke-PySpark' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:available = Test-Tool 'py_spark'
    }

    It 'outputs version info' {
        if (-not $script:available) {
            Set-ItResult -Skipped -Because 'tool_pyspark_missing'; return
        }
        $result = Invoke-PySpark '--version' -PassThru -Silent -NoAssert
        $result.Full | Should -Not -BeNullOrEmpty
    }
}
