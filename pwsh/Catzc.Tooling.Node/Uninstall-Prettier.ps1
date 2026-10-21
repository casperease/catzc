<#
---
catzc:
  immutable:
    with_body_sha: "31fdfd990c26"
  edges:
    docs: "[Uninstall-Prettier.ps1.md](../../docs/references/pwsh/catzc-tooling-node/Uninstall-Prettier.ps1.md)"
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
