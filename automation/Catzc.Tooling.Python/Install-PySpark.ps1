<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Python/Install-PySpark.ps1
    name: install-py-spark
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Installs PySpark into the uv-managed Python via `uv pip`.
    description: |-
      Installs pyspark with `uv pip install --system` so it is importable in the uv-managed Python. Requires uv
      and Python (depends_on python for install ordering). Java is a runtime dependency — Invoke-PySpark asserts
      it before PySpark is used.
    parameters:
      Version: PySpark version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-PySpark
      - Install-PySpark -Version '3.5'
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
