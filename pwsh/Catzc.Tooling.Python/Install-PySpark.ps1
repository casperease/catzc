<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-python/Install-PySpark.ps1.md"
  warning: "Generated Header"
---
#>

function Install-PySpark {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'py_spark').version,
        [switch] $Force
    )

    Install-PipTool -Tool 'py_spark' -Version $Version -Force:$Force
}
