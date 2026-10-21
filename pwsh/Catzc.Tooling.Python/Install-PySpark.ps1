<#
---
catzc:
  immutable:
    with_body_sha: f78ba69b3c65
  edges:
    docs: "[Install-PySpark.ps1.md](../../docs/references/pwsh/catzc-tooling-python/Install-PySpark.ps1.md)"
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
