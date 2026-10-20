<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Invoke-PySpark.ps1
    name: invoke-py-spark
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-PySpark.Tests.ps1
    docs: "[Invoke-PySpark.ps1.md](docs/references/pwsh/catzc-tooling-python/Invoke-PySpark.ps1.md)"
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
