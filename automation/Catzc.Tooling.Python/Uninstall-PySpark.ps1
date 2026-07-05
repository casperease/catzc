<#
.SYNOPSIS
    Uninstalls PySpark from the uv-managed Python via `uv pip`.
.DESCRIPTION
    Idempotent — skips if PySpark is not installed or if Python is
    not available (nothing to uninstall).
.EXAMPLE
    Uninstall-PySpark
#>
function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
