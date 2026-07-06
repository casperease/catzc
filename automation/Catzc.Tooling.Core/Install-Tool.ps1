<#
.SYNOPSIS
    Installs a tool using the platform package manager.
.DESCRIPTION
    Uses winget on Windows, brew on macOS, and apt-get on Linux.
    Idempotent — skips if already installed at the correct version.
    If the wrong version is found, -Force uninstalls and reinstalls.
    Without -Force, throws with instructions.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER Version
    Version override. Defaults to the locked version.
.PARAMETER Force
    Automatically uninstall the wrong version before installing the correct one.
#>
function Install-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool

    # npm-managed tools (cspell, prettier, markdownlint) are installed with npm, not a platform package
    # manager, so Install-Tool cannot handle them. Fail here — before the -Force path routes into
    # Uninstall-Tool — so the message names Install-$command (what the caller wanted), not a stray winget
    # detail from deeper in the chain. Bulk provisioning already dispatches these to Install-$command.
    if ($config.npm_package) {
        throw "$Tool is an npm-managed tool. Install-Tool manages winget/brew/apt packages only — use Install-$command (npm) instead."
    }

    if (-not $Version) {
        $Version = $config.version
    }

    # Idempotent: skip if already installed at the correct version
    if (Test-Command $config.command) {
        $location = (Get-Command $config.command).Source

        $installed = Get-ToolVersion -Config $config

        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "$Tool $Version is already installed"
            return
        }

        if (-not $installed) {
            # Version unparseable (e.g., Windows Store stub) — not a real installation, skip to install
            Write-Verbose "Could not parse version from '$location' — treating as not installed"
        }
        elseif ($Force) {
            Write-Verbose "$Tool $installed found at '$location' — uninstalling before installing $Version"
            Uninstall-Tool -Tool $Tool
        }
        else {
            throw "$Tool version mismatch: expected $Version.x, found $installed at '$location'. Run Install-$command -Force to replace, or uninstall manually."
        }
    }

    if ($IsWindows) {
        Assert-NotNullOrWhitespace $config.winget_id -ErrorText "$Tool has no WingetId — use Install-$command directly"
        Assert-Command winget
        $packageId = $config.winget_id -f $Version

        # --force: winget may see a Store stub or stale alias and report "already installed"
        # even though no real installation exists. Force ensures it always installs.
        if ($config.winget_scope -eq 'user') {
            Invoke-Executable "winget install --id $packageId --scope user --accept-source-agreements --accept-package-agreements --silent --force"
        }
        else {
            Assert-IsAdministrator -ErrorText "Install-$command on Windows requires Administrator (winget machine-scope). Run as Administrator or install $Tool manually."
            Invoke-Executable "winget install --id $packageId --accept-source-agreements --accept-package-agreements --silent --force"
        }
    }
    elseif ($IsMacOS) {
        Assert-NotNullOrWhitespace $config.brew_formula -ErrorText "$Tool has no BrewFormula — use Install-$command directly"
        Assert-Command brew
        $formula = $config.brew_formula -f $Version
        Invoke-Executable "brew install $formula"
    }
    elseif ($IsLinux) {
        Assert-NotNullOrWhitespace $config.apt_package -ErrorText "$Tool has no AptPackage — use Install-$command directly"
        # Linux package installation via apt-get requires root. No user-space
        # package-manager alternative exists without adding a new tool dependency.
        # Two paths to eliminate this requirement:
        #   Option A: Vendor the uv binary (astral.sh/uv, ~25 MB static Rust binary).
        #             uv python install <ver> is fully user-space on all platforms.
        #             Also gives isolated tool installs (uv tool install azure-cli).
        #   Option B: Upgrade Python to 3.12+ in tools.yml. Fixes the Windows UAC
        #             issue (3.11 burn installer) but Linux still needs admin here.
        Assert-IsAdministrator -ErrorText "Install-$command on Linux requires root (apt-get). Run as root or install $Tool manually."
        Assert-Command apt-get
        $package = $config.apt_package -f $Version
        Invoke-Executable 'sudo apt-get update -qq'
        Invoke-Executable "sudo apt-get install -y $package"
    }
    else {
        throw 'Unsupported platform for tool installation'
    }

    Sync-SessionPath

    # winget portable packages resolve through a symlink in WinGet\Links that must be on PATH; creating that
    # symlink needs Developer Mode (or admin), so on a plain user account the command lands under WinGet\Packages
    # on no PATH at all. When it is still unresolved after the registry sync, recover it: find the command in the
    # Packages tree and prepend its directory to the session PATH. (Enabling Developer Mode lets winget do this
    # itself and is the cleaner fix.)
    if ($IsWindows -and -not (Get-Command $config.command -CommandType Application -ErrorAction Ignore)) {
        $pkgRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
        if (Test-Path $pkgRoot) {
            $exe = Get-ChildItem -Path $pkgRoot -Filter "$($config.command).exe" -Recurse -File -ErrorAction Ignore |
                Select-Object -First 1
            if ($exe -and (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $exe.DirectoryName)) {
                $env:PATH = "$($exe.DirectoryName)$([System.IO.Path]::PathSeparator)$env:PATH"
            }
        }
    }

    Assert-Command $config.command -ErrorText "$Tool was installed but '$($config.command)' is not on PATH. You may need to restart your shell."

    # Verify the actual installed version matches what we asked for.
    $actualVersion = Get-ToolVersion -Config $config

    if ($actualVersion -and $actualVersion.StartsWith($Version)) {
        Write-Message "$Tool $actualVersion installed successfully"
    }
    elseif ($actualVersion) {
        Write-Message "$Tool installed but version $actualVersion does not match expected $Version.x — package manager may have installed a different version"
    }
    else {
        Write-Message "$Tool installed but could not verify version"
    }
}
