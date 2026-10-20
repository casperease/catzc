<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Node/Uninstall-Markdownlint.ps1
    name: uninstall-markdownlint
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
    docs: "[Uninstall-Markdownlint.ps1.md](docs/references/pwsh/catzc-tooling-node/Uninstall-Markdownlint.ps1.md)"
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
