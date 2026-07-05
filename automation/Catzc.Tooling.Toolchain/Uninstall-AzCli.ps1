<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    Removes the uv-managed install (`uv tool uninstall azure-cli`) via Uninstall-UvTool. Idempotent — skips
    if not installed. For an Azure CLI installed outside the tooling system (e.g. a lingering machine-scope
    MSI), use Remove-AzCli.
.EXAMPLE
    Uninstall-AzCli
#>
function Uninstall-AzCli {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'az_cli'
}
