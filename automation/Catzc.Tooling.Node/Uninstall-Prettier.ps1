<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Node/Uninstall-Prettier.ps1
    name: uninstall-prettier
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
#>

function Uninstall-Prettier {
    [CmdletBinding()]
    param()

    $config = Get-ToolConfig -Tool 'prettier'

    if (-not (Test-Command $config.command)) {
        Write-Message 'Prettier is not installed'
        return
    }

    if (-not (Test-Command 'npm')) {
        Write-Message 'npm is not available — cannot uninstall Prettier via npm'
        return
    }

    Invoke-Npm "uninstall -g $($config.npm_package)"
}
