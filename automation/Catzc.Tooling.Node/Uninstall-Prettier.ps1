<#
.SYNOPSIS
    Uninstalls Prettier (the global npm package).
.DESCRIPTION
    Idempotent — skips if Prettier or npm is not present (nothing to uninstall).
.EXAMPLE
    Uninstall-Prettier
#>
function Uninstall-Prettier {
    [CmdletBinding()]
    param()

    $config = Get-ToolConfig -Tool 'prettier'

    if (-not (Test-Command $config.command)) {
        Write-Message 'Prettier is not installed'
        return
    }

    if (-not (Test-Command 'npm')) {
        Write-Message 'npm is not available — cannot uninstall Prettier via npm'
        return
    }

    Invoke-Npm "uninstall -g $($config.npm_package)"
}
