<#
---
catzc:
  immutable:
    with_body_sha: aaeb52acb51b
  edges:
    code: pwsh/Catzc.Tooling.Python/Invoke-PySpark.ps1
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
