<#
---
catzc:
  immutable:
    with_body_sha: c0593e943c02
  edges:
    docs: "[Uninstall-PySpark.ps1.md](docs/references/pwsh/catzc-tooling-python/Uninstall-PySpark.ps1.md)"
---
#>

function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
