<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs:
      - ADR-AUTO-ENGINE
---
#>

<#
.SYNOPSIS
    Installs ShellCheck, the analyzer for the repository's shell scripts, at the tools.yml pin.
.DESCRIPTION
    Linux uses apt-get and so needs root, while Windows and macOS stay user-scope through winget or brew.
.PARAMETER Version
    The version prefix to install. Default: the tools.yml pin.
.PARAMETER Force
    Replace an installed ShellCheck at another version.
.EXAMPLE
    Install-Shellcheck
#>
function Install-Shellcheck {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'shellcheck').version,

        [switch] $Force
    )

    if ($IsLinux) {
        $config = Get-ToolConfig -Tool 'shellcheck'
        if (Test-Command $config.command) {
            $installed = Get-ToolVersion -Config $config
            if ($installed -and $installed.StartsWith($Version)) {
                Write-Message "ShellCheck $Version is already installed"
                return
            }
            if ($installed -and -not $Force) {
                $location = (Get-Command $config.command).Source
                throw "ShellCheck version mismatch: expected $Version.x, found $installed at '$location'. Run Install-Shellcheck -Force to replace, or uninstall manually."
            }
        }
        Assert-IsAdministrator -ErrorText 'Install-Shellcheck on Linux requires root (apt-get). Run as root or install ShellCheck manually.'
        Assert-Command apt-get
        Invoke-Executable 'sudo apt-get update -qq'
        Invoke-Executable 'sudo apt-get install -y shellcheck'
        Assert-Command shellcheck -ErrorText 'ShellCheck was installed but is not on PATH. You may need to restart your shell.'
        Write-Message "ShellCheck $Version installed successfully"
        return
    }

    # Windows / macOS: Install-Tool (winget / brew).
    Install-Tool -Tool 'shellcheck' -Version $Version -Force:$Force
}
