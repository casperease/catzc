<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-python/Uninstall-Python.ps1.md"
  warning: "Generated Header"
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
