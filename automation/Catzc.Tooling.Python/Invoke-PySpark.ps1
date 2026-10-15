<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-PySpark.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
---
#>

<#
.SYNOPSIS
    Runs pyspark with the given arguments.
.DESCRIPTION
    The Java check comes from DependsOn in tools.yml, not from this function; a dry run skips both asserts.
    [comment:1](/docs/references/automation/catzc-tooling-python/Invoke-PySpark.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to pyspark.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-PySpark '--version'
.EXAMPLE
    Invoke-PySpark '--version' -DryRun
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
