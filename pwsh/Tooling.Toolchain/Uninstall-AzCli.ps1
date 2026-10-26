function Uninstall-AzCli {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    # Catching only under -Remove is the escalation's one purpose, not catch-and-continue; otherwise the failure propagates.
    try {
        Uninstall-UvVenvTool -Tool 'az_cli'
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-AzCli."
    }

    if ($Remove) {
        Remove-AzCli -Force:$Force
    }
}
