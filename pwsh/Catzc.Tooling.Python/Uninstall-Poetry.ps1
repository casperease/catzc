<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-python/Uninstall-Poetry.ps1.md"
  warning: "Generated Header"
---
#>

function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
