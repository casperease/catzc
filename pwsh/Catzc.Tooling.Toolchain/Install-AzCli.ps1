<#
---
catzc:
  immutable:
    with_body_sha: "9b7d4fb1edc3"
  edges:
    docs: "[Install-AzCli.ps1.md](../../docs/references/pwsh/catzc-tooling-toolchain/Install-AzCli.ps1.md)"
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
