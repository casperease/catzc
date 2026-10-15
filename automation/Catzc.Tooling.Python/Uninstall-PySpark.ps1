<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Uninstall-PySpark.ps1
    kind: public-function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Uninstalls PySpark from the uv-managed Python via `uv pip`.
.DESCRIPTION
    A missing Python counts as nothing to uninstall, not as an error, so a repeat run is safe.
.EXAMPLE
    Uninstall-PySpark
#>
function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
