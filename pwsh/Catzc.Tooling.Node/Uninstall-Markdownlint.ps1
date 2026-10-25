<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Uninstall-Markdownlint.ps1.md"
  warning: "Generated Header"
---
#>

function Uninstall-Markdownlint {
    [CmdletBinding()]
    param()

    $config = Get-ToolConfig -Tool 'markdownlint'

    if (-not (Test-Command $config.command)) {
        Write-Message 'markdownlint-cli2 is not installed'
        return
    }

    if (-not (Test-Command 'npm')) {
        Write-Message 'npm is not available — cannot uninstall markdownlint-cli2 via npm'
        return
    }

    Invoke-Npm "uninstall -g $($config.npm_package)"
}
