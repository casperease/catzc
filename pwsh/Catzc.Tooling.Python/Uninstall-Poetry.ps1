<#
---
catzc:
  immutable:
    with_body_sha: "4387be840e78"
  edges:
    docs: "[Uninstall-Poetry.ps1.md](../../docs/references/pwsh/catzc-tooling-python/Uninstall-Poetry.ps1.md)"
---
#>

function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
