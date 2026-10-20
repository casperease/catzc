<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Node/Install-Markdownlint.ps1
    name: install-markdownlint
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
    docs: "[Install-Markdownlint.ps1.md](docs/references/pwsh/catzc-tooling-node/Install-Markdownlint.ps1.md)"
---
#>

function Install-Markdownlint {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'markdownlint').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'markdownlint'

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
