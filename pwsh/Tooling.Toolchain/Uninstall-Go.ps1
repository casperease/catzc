function Uninstall-Go {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    # Best-effort only under -Remove, where a failure is logged and the escalation proceeds; otherwise it propagates.
    try {
        $config = Get-ToolConfig -Tool 'go'
        $installDir = Get-ScriptInstallDir -Config $config

        if (-not (Test-Path -LiteralPath $installDir)) {
            Write-Message "Go is not installed at '$installDir' — nothing to do"
        }
        else {
            Write-Message "Removing '$installDir'"
            Remove-Item -LiteralPath $installDir -Recurse -Force
            Remove-PermanentPath (Join-Path $installDir 'bin') -Label 'Install-Go'
            Write-Message "Go uninstalled from '$installDir'"
        }
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-Go."
    }

    if ($Remove) {
        Remove-Go -Force:$Force
    }
}
