<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Install-Prettier.ps1
    kind: function
    module: Catzc.Tooling.Node
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Installs Prettier (the prettier formatter engine's CLI) globally via npm.
.DESCRIPTION
    A wrong installed version is replaced only with -Force; the right one is left alone.
.PARAMETER Version
    Prettier version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Prettier
.EXAMPLE
    Install-Prettier -Force
#>
function Install-Prettier {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'prettier').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'prettier'

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # Idempotent: skip if already installed at the locked version.
    if (Test-Command $config.command) {
        $installed = Get-ToolVersion -Config $config

        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Prettier $Version is already installed"
            return
        }

        if ($installed -and -not $Force) {
            $location = (Get-Command $config.command).Source
            throw "Prettier version mismatch: expected $Version.x, found $installed at '$location'. " +
            'Run Install-Prettier -Force to replace.'
        }
    }

    Invoke-Npm "install -g $($config.npm_package)@$Version"
    Assert-Command prettier -ErrorText 'Prettier was installed but is not on PATH. You may need to restart your shell.'
    Write-Message "Prettier $Version installed successfully"
}
