<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Install-Poetry.ps1
    name: install-poetry
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
    docs: "[Install-Poetry.ps1.md](docs/references/pwsh/catzc-tooling-python/Install-Poetry.ps1.md)"
---
#>

function Install-Poetry {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'poetry').version,
        [switch] $Force
    )

    Install-UvTool -Tool 'poetry' -Version $Version -Force:$Force
}
