<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    Removes az's dedicated uv venv via Uninstall-UvVenvTool. Idempotent — skips if not installed. For an Azure
    CLI installed outside the tooling system (e.g. a lingering machine-scope MSI), use Remove-AzCli.
.EXAMPLE
    Uninstall-AzCli
#>
function Uninstall-AzCli {
    [CmdletBinding()]
    param()

    Uninstall-UvVenvTool -Tool 'az_cli'
}
