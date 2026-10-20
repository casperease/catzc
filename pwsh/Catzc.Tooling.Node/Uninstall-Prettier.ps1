<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Node/Uninstall-Prettier.ps1
    name: uninstall-prettier
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Uninstall-Prettier.ps1.md](docs/references/pwsh/catzc-tooling-node/Uninstall-Prettier.ps1.md)"
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
