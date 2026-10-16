<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Node/Uninstall-Prettier.ps1
    name: uninstall-prettier
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Uninstalls Prettier (the global npm package).
    description: Idempotent — skips if Prettier or npm is not present (nothing to uninstall).
    examples:
      - Uninstall-Prettier
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
