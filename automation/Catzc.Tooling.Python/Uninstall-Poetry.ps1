<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Uninstalls Poetry.
.DESCRIPTION
    Skips quietly when Poetry is not installed, so a repeat run is safe.
.EXAMPLE
    Uninstall-Poetry
#>
function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
