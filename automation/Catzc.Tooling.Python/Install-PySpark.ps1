<#
.SYNOPSIS
    Installs PySpark into the uv-managed Python via `uv pip`.
.DESCRIPTION
    Installs pyspark with `uv pip install --system` so it is importable in the uv-managed Python. Requires uv
    and Python (depends_on python for install ordering). Java is a runtime dependency — Invoke-PySpark asserts
    it before PySpark is used.
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
        [string] $Version,
        [switch] $Force
    )

    Install-PipTool -Tool 'py_spark' -Version $Version -Force:$Force
}
