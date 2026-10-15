<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Go.ps1
    kind: automation-function
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Uninstalls the Go toolchain installed by Install-Go.
    description: |-
      Removes the managed user-space home (Get-ScriptInstallDir: Windows %LOCALAPPDATA%\go, Unix ~/.go) and takes
      its bin folder off the session and persistent PATH — the managed uninstall. Idempotent — skips when the home
      does not exist. A Go installed elsewhere (a machine-wide MSI, a distro package) is not the managed install and
      is left untouched. The module cache and build cache (GOPATH, GOCACHE) are Go's own data, not the install, and
      are kept.
    examples:
      - Uninstall-Go
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
