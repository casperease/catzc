<#
.SYNOPSIS
    Uninstalls PySpark from the uv-managed Python via `uv pip`.
.DESCRIPTION
    A missing Python counts as nothing to uninstall, not as an error, so a repeat run is safe.
    [comment:1](/docs/references/automation/catzc-tooling-python/Uninstall-PySpark.ps1.md#comment1)
.EXAMPLE
    Uninstall-PySpark
#>
function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
