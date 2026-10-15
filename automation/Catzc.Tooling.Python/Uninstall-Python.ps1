<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Uninstall-Python.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
---
#>

<#
.SYNOPSIS
    Uninstalls the uv-provisioned Python.
.DESCRIPTION
    Removes the uv-managed CPython (`uv python uninstall <version>`). Idempotent — skips if not installed.
.PARAMETER Version
    Python version to uninstall. Defaults to the locked version in Get-ToolConfig.
.EXAMPLE
    Uninstall-Python
.EXAMPLE
    Uninstall-Python -Version '3.12'
#>
function Uninstall-Python {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'python').version
    )

    $config = Get-ToolConfig -Tool 'python'

    if (-not (Test-Command $config.command)) {
        Write-Message 'python is not installed — nothing to do'
        return
    }

    Invoke-Uv "python uninstall $Version"
    Write-Message "python $Version uninstalled"
}
