<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Uninstall-Markdownlint.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Node
    visibility: public
  config:
    synopsis: Uninstalls markdownlint-cli2 (the global npm package).
    description: Idempotent — skips if markdownlint-cli2 or npm is not present (nothing to uninstall).
    examples:
      - Uninstall-Markdownlint
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
