<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Go.ps1
    name: uninstall-go
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Tooling.Toolchain/tests/Uninstall-Go.Tests.ps1
---
#>

function Uninstall-Go {
    [CmdletBinding()]
    param()

    $config = Get-ToolConfig -Tool 'go'
    $installDir = Get-ScriptInstallDir -Config $config

    if (-not (Test-Path -LiteralPath $installDir)) {
        Write-Message "Go is not installed at '$installDir' — nothing to do"
        return
    }

    Write-Message "Removing '$installDir'"
    Remove-Item -LiteralPath $installDir -Recurse -Force
    Remove-PermanentPath (Join-Path $installDir 'bin') -Label 'Install-Go'
    Write-Message "Go uninstalled from '$installDir'"
}
