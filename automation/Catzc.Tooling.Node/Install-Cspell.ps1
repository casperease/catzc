<#
.SYNOPSIS
    Installs cspell (the Code Spell Checker CLI) globally via npm.
.DESCRIPTION
    cspell is the spell-checker behind Test-Spelling. It is installed globally with npm at the version
    locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the locked
    version; -Force replaces a wrong version.
.PARAMETER Version
    cspell version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Cspell
.EXAMPLE
    Install-Cspell -Force
#>
function Install-Cspell {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'cspell'
    if (-not $Version) {
        $Version = $config.version
    }

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # Idempotent: skip if already installed at the locked version.
    if (Test-Command $config.command) {
        $installed = Get-ToolVersion -Config $config

        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "cspell $Version is already installed"
            return
        }

        if ($installed -and -not $Force) {
            $location = (Get-Command $config.command).Source
            throw "cspell version mismatch: expected $Version.x, found $installed at '$location'. " +
            'Run Install-Cspell -Force to replace.'
        }
    }

    Invoke-Npm "install -g $($config.npm_package)@$Version"
    Assert-Command cspell -ErrorText 'cspell was installed but is not on PATH. You may need to restart your shell.'
    Write-Message "cspell $Version installed successfully"
}
