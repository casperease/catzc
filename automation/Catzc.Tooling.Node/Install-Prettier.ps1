<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Node/Install-Prettier.ps1
    name: install-prettier
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Installs Prettier (the prettier formatter engine's CLI) globally via npm.
    description: |-
      Prettier is the engine Format-Code runs for every file language languages.yml gives `formatter: prettier`
      (Markdown, pipeline YAML). It is installed globally with npm at the version locked in tools.yml. Requires
      Node.js (npm). Idempotent — skips if already installed at the locked version; -Force replaces a wrong version.
    parameters:
      Version: Prettier version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-Prettier
      - Install-Prettier -Force
---
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
