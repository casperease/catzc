<#
---
catzc:
  immutable:
    with_body_sha: f3b69696f798
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-PySpark.Tests.ps1
    docs: "[Invoke-PySpark.ps1.md](../../docs/references/pwsh/catzc-tooling-python/Invoke-PySpark.ps1.md)"
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
