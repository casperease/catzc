<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Node/Install-Cspell.ps1
    name: install-cspell
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Install-Cspell.ps1.md](docs/references/pwsh/catzc-tooling-node/Install-Cspell.ps1.md)"
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
