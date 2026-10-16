<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/Uninstall-Python.ps1
    name: uninstall-python
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Uninstalls the uv-provisioned Python.
    description: Removes the uv-managed CPython (`uv python uninstall <version>`). Idempotent — skips if not installed.
    parameters:
      Version: Python version to uninstall. Defaults to the locked version in Get-ToolConfig.
    examples:
      - Uninstall-Python
      - Uninstall-Python -Version '3.12'
---
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
