<#
.SYNOPSIS
    Installs markdownlint-cli2 (the Markdown linter CLI) globally via npm.
.DESCRIPTION
    markdownlint-cli2 is the linter behind Test-Markdownlint. It is installed globally with npm at the
    version locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the
    locked version; -Force replaces a wrong version.
.PARAMETER Version
    markdownlint-cli2 version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Markdownlint
.EXAMPLE
    Install-Markdownlint -Force
#>
function Install-Markdownlint {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'markdownlint'
    if (-not $Version) {
        $Version = $config.version
    }

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # Idempotent: skip if already installed at the locked version.
    if (Test-Command $config.command) {
        $installed = Get-ToolVersion -Config $config

        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "markdownlint-cli2 $Version is already installed"
            return
        }

        if ($installed -and -not $Force) {
            $location = (Get-Command $config.command).Source
            throw "markdownlint-cli2 version mismatch: expected $Version.x, found $installed at '$location'. " +
            'Run Install-Markdownlint -Force to replace.'
        }
    }

    Invoke-Npm "install -g $($config.npm_package)@$Version"
    Assert-Command markdownlint-cli2 -ErrorText 'markdownlint-cli2 was installed but is not on PATH. You may need to restart your shell.'
    Write-Message "markdownlint-cli2 $Version installed successfully"
}
