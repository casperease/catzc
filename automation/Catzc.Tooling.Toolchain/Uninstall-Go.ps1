<#
.SYNOPSIS
    Uninstalls the Go toolchain installed by Install-Go.
.DESCRIPTION
    Go's module and build caches (GOPATH, GOCACHE) are its own data, not the install, so they are kept.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Go.ps1.md#comment1)
.EXAMPLE
    Uninstall-Go
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
