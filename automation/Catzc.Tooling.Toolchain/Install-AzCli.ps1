<#
.SYNOPSIS
    Installs the Azure CLI.
.DESCRIPTION
    macOS: Homebrew (user-space) via Install-Tool.
    Windows: winget (Microsoft.AzureCLI — MSI, machine-scope, requires Administrator, hash-verified) via
    Install-Tool.
    Linux: the official Microsoft install script (https://aka.ms/InstallAzureCLIDeb), which registers the
    Microsoft apt repo and installs azure-cli (so apt/dpkg then track it). Requires root.

    az ships its own Python, so it does not depend on the system `python` tool. Idempotent — skips if the
    correct version is already on PATH.
.PARAMETER Version
    Azure CLI version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version (Windows/macOS, where Install-Tool manages it).
.EXAMPLE
    Install-AzCli
.EXAMPLE
    Install-AzCli -Version '2.74'
#>
function Install-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    # Linux: the azure-cli apt package needs the Microsoft apt repo configured first, which the generic
    # apt path (apt-get install) does not do. Use the official Microsoft script, which sets up the repo and
    # installs azure-cli; dpkg then tracks it, so Uninstall-AzCli / Get-ToolsStatus treat it as apt-managed.
    if ($IsLinux) {
        $config = Get-ToolConfig -Tool 'az_cli'
        if (-not $Version) {
            $Version = $config.version
        }

        # Idempotent: skip if the correct version is already on PATH.
        if (Test-Command $config.command) {
            $installed = Get-ToolVersion -Config $config
            if ($installed -and $installed.StartsWith($Version)) {
                Write-Message "az_cli $Version is already installed"
                return
            }
        }

        Assert-IsAdministrator -ErrorText (
            'Install-AzCli on Linux runs the official Microsoft install script (apt) via sudo. ' +
            'Run as root or install the Azure CLI manually.'
        )
        Assert-Command curl
        Write-Message 'Installing Azure CLI via https://aka.ms/InstallAzureCLIDeb'
        Invoke-Executable 'curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash'

        Sync-SessionPath
        Assert-Command $config.command -ErrorText "az_cli was installed but '$($config.command)' is not on PATH. You may need to restart your shell."
        return
    }

    # macOS (brew) + Windows (winget): both managed by the generic package-manager engine.
    Install-Tool -Tool 'az_cli' -Version $Version -Force:$Force
}
