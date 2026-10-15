<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Uninstall-Cspell.ps1
    kind: public-function
    module: Catzc.Tooling.Node
    visibility: public
  config:
    synopsis: Uninstalls cspell (the global npm package).
    description: Idempotent — skips if cspell or npm is not present (nothing to uninstall).
    examples:
      - Uninstall-Cspell
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
