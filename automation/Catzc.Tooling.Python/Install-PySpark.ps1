# catzc:
#   path: automation/Catzc.Tooling.Python/Install-PySpark.ps1
#   module: Catzc.Tooling.Python
#   visibility: public

<#
.SYNOPSIS
    Installs PySpark into the uv-managed Python via `uv pip`.
.DESCRIPTION
    Java is a runtime dependency that this install does not provide; Invoke-PySpark asserts it before each use.
    [comment:1](/docs/references/automation/catzc-tooling-python/Install-PySpark.ps1.md#comment1)
.PARAMETER Version
    PySpark version to install. Defaults to the locked version in Get-ToolConfig.
.EXAMPLE
    Install-PySpark
.EXAMPLE
    Install-PySpark -Version '3.5'
#>
function Install-PySpark {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'py_spark').version,
        [switch] $Force
    )

    Install-PipTool -Tool 'py_spark' -Version $Version -Force:$Force
}
