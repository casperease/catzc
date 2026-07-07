<#
.SYNOPSIS
    Installs Node.js via the platform package manager.
.DESCRIPTION
    Installs Node.js (which includes npm) at the locked major version. Windows: winget
    (OpenJS.NodeJS.LTS). macOS: Homebrew (node@<major>). Linux: the NodeSource apt
    repository for the locked major (configured inline if not already present), because
    the distro `nodejs` package lags the pin badly (Ubuntu jammy ships Node 12).
    Idempotent — skips if already installed at the correct version.

    NOT for CI pipelines. In Azure DevOps, use the native UseNode task
    which activates pre-cached versions instantly:

        - task: UseNode@1
          inputs:
            version: '22.x'
.PARAMETER Version
    Node.js major version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-NodeJs
.EXAMPLE
    Install-NodeJs -Force
#>
function Install-NodeJs {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    Assert-False (Test-IsRunningInPipeline) -ErrorText (
        'Install-NodeJs is for developer workstations, not CI. ' +
        "In ADO pipelines, use the native task: - task: UseNode@1 inputs: version: '22.x'"
    )

    if ($IsLinux) {
        $config = Get-ToolConfig -Tool 'node_js'
        if (-not $Version) {
            $Version = $config.version
        }

        # Idempotent: skip if already installed at the correct version
        if (Test-Command $config.command) {
            $installed = Get-ToolVersion -Config $config

            if ($installed -and $installed.StartsWith($Version)) {
                Write-Message "node_js $Version is already installed"
                return
            }

            if ($installed -and -not $Force) {
                $location = (Get-Command $config.command).Source
                throw "node_js version mismatch: expected $Version.x, found $installed at '$location'. Run Install-NodeJs -Force to replace, or uninstall manually."
            }
        }

        Assert-IsAdministrator -ErrorText 'Install-NodeJs on Linux requires root (apt-get). Run as root or install node_js manually.'
        Assert-Command apt-get

        # The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so install
        # from the NodeSource apt repository for the locked major — mirroring the HashiCorp repo setup in
        # Install-Terraform. The repo URL embeds the major, so re-write the source when the pin changes.
        $sourcePath = '/etc/apt/sources.list.d/nodesource.list'
        $gpgKeyPath = '/usr/share/keyrings/nodesource.gpg'
        $repoLine = "deb [signed-by=$gpgKeyPath] https://deb.nodesource.com/node_$Version.x nodistro main"
        $currentRepo = ''
        if (Test-Path $sourcePath) {
            $currentRepo = (Get-Content $sourcePath -Raw).Trim()
        }
        if ($currentRepo -ne $repoLine) {
            Write-Message "Configuring the NodeSource apt repository for Node $Version"
            Invoke-Executable 'sudo apt-get update -qq'
            Invoke-Executable 'sudo apt-get install -y ca-certificates gnupg'
            $gpgTmp = Join-Path ([IO.Path]::GetTempPath()) 'nodesource.gpg.key'
            Invoke-WebRequest -Uri 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key' -OutFile $gpgTmp -UseBasicParsing
            Invoke-Executable "sudo gpg --batch --yes --dearmor -o $gpgKeyPath $gpgTmp"
            Remove-Item $gpgTmp -Force -ErrorAction SilentlyContinue

            $repoTmp = Join-Path ([IO.Path]::GetTempPath()) 'nodesource.list'
            Set-Content -Path $repoTmp -Value $repoLine -Force
            Invoke-Executable "sudo cp $repoTmp $sourcePath"
            Remove-Item $repoTmp -Force -ErrorAction SilentlyContinue
        }

        Invoke-Executable 'sudo apt-get update -qq'
        Invoke-Executable 'sudo apt-get install -y nodejs'
        Assert-Command node -ErrorText 'node_js was installed but is not on PATH. You may need to restart your shell.'

        $actualVersion = Get-ToolVersion -Config $config
        Assert-True ($actualVersion -and $actualVersion.StartsWith($Version)) -ErrorText (
            "node_js installed from NodeSource but resolved to '$actualVersion', not $Version.x — check the node_$Version.x repo exists."
        )
        Write-Message "node_js $actualVersion installed successfully"
        return
    }

    # Windows / macOS: delegate to Install-Tool (winget / brew)
    Install-Tool -Tool 'node_js' -Version $Version -Force:$Force
}
