<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Node/Uninstall-Cspell.ps1
    name: uninstall-cspell
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

function Uninstall-Cspell {
    [CmdletBinding()]
    param()

    $config = Get-ToolConfig -Tool 'cspell'

    if (-not (Test-Command $config.command)) {
        Write-Message 'cspell is not installed'
        return
    }

    if (-not (Test-Command 'npm')) {
        Write-Message 'npm is not available — cannot uninstall cspell via npm'
        return
    }

    Invoke-Npm "uninstall -g $($config.npm_package)"
}
