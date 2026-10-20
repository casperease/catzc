<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Install-AzCli.ps1
    name: install-az-cli
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Install-AzCli.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Install-AzCli.ps1.md)"
---
#>

function Install-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'az_cli').version,
        [switch] $Force
    )

    Install-UvVenvTool -Tool 'az_cli' -Version $Version -Force:$Force
}
