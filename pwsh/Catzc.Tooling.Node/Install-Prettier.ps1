<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Install-Prettier.ps1.md"
  header: "generated"
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
