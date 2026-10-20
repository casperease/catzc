<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Install-PySpark.ps1
    name: install-py-spark
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Install-PySpark.ps1.md](docs/references/pwsh/catzc-tooling-python/Install-PySpark.ps1.md)"
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
