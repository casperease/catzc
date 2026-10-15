<#
.SYNOPSIS
    Uninstalls Poetry.
.DESCRIPTION
    Removes the uv-managed install (`uv tool uninstall poetry`) via Uninstall-UvTool.
    [comment:1](/docs/references/automation/catzc-tooling-python/Uninstall-Poetry.ps1.md#comment1)
.EXAMPLE
    Uninstall-Poetry
#>
function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
