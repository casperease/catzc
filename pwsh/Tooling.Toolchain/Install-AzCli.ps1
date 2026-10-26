<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Install-AzCli.ps1.md"
  header: "generated"
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
