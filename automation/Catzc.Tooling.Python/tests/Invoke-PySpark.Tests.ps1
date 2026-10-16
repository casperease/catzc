<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/tests/Invoke-PySpark.Tests.ps1
    folder: tests
    name: invoke-py-spark-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-PySpark' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-PySpark '--version' -DryRun | Should -Be 'pyspark --version'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-PySpark '--master local[4] --name test' -DryRun | Should -Be 'pyspark --master local[4] --name test'
    }
}
