<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/tests/Invoke-PySpark.L2.Tests.ps1
    folder: tests
    name: invoke-py-spark-l2-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

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
