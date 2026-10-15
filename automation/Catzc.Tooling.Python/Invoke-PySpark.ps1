<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-PySpark.ps1
    kind: automation-function
    module: Catzc.Tooling.Python
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Python/tests/Invoke-PySpark.Tests.ps1
  config:
    synopsis: Runs pyspark with the given arguments.
    description: |-
      Asserts that the installed PySpark version matches the locked version
      in Get-ToolConfig before executing the command. Also asserts Java
      is available (DependsOn in tools.yml).
    parameters:
      Arguments: Arguments to pass to pyspark.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-PySpark '--version'
      - Invoke-PySpark '--version' -DryRun
---
#>

function Invoke-PySpark {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if (-not $DryRun) {
        Assert-Tool 'py_spark'
    }

    Invoke-Executable "pyspark $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
