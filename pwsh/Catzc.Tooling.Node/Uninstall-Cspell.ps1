<#
---
catzc:
  immutable:
    with_body_sha: fd8f36be3f79
  edges:
    docs: "[Uninstall-Cspell.ps1.md](../../docs/references/pwsh/catzc-tooling-node/Uninstall-Cspell.ps1.md)"
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
