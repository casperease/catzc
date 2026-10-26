<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-python/Install-Poetry.ps1.md"
  header: "generated"
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
