<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Install-Cspell.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Tooling.Node
    visibility: public
  config:
    synopsis: Installs cspell (the Code Spell Checker CLI) globally via npm.
    description: |-
      cspell is the spell-checker behind Test-Spelling. It is installed globally with npm at the version
      locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the locked
      version; -Force replaces a wrong version.
    parameters:
      Version: cspell version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-Cspell
      - Install-Cspell -Force
---
#>

function Install-Cspell {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'cspell').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'cspell'

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
