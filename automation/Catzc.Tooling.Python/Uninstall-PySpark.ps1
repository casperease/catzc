<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/Uninstall-PySpark.ps1
    name: uninstall-py-spark
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Uninstalls PySpark from the uv-managed Python via `uv pip`.
    description: |-
      Idempotent — skips if PySpark is not installed or if Python is
      not available (nothing to uninstall).
    examples:
      - Uninstall-PySpark
---
#>

function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
