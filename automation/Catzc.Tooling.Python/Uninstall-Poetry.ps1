<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1
    name: uninstall-poetry
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

function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
