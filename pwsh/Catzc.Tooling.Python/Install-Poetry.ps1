<#
---
catzc:
  immutable:
    with_body_sha: "168a34f15a2b"
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
