<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Python/Uninstall-PySpark.ps1
    name: uninstall-py-spark
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
#>

function Uninstall-PySpark {
    [CmdletBinding()]
    param()

    Uninstall-PipTool -Tool 'py_spark'
}
