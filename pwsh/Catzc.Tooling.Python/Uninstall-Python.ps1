<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Uninstall-Python.ps1
    name: uninstall-python
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Uninstall-Python.ps1.md](docs/references/pwsh/catzc-tooling-python/Uninstall-Python.ps1.md)"
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
