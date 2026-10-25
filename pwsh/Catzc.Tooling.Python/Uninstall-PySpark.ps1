<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-python/Uninstall-PySpark.ps1.md"
  warning: "Generated Header"
---
#>

function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
