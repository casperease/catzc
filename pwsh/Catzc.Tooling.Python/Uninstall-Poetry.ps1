<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Uninstall-Poetry.ps1
    name: uninstall-poetry
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Uninstall-Poetry.ps1.md](docs/references/pwsh/catzc-tooling-python/Uninstall-Poetry.ps1.md)"
---
#>

function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
