<#
.SYNOPSIS
    Uninstalls Poetry.
.DESCRIPTION
    Skips quietly when Poetry is not installed, so a repeat run is safe.
    [comment:1](/docs/references/automation/catzc-tooling-python/Uninstall-Poetry.ps1.md#comment1)
.EXAMPLE
    Uninstall-Poetry
#>
function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
