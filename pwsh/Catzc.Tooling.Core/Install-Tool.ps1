<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Install-Tool.ps1.md"
  header: "generated"
---
#>

function Install-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [string] $Version = (Get-ToolConfig -Tool $Tool).version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool

    if ($config.npm_package) {
        throw "$Tool is an npm-managed tool. Install-Tool manages winget/brew/apt packages only — use Install-$command (npm) instead."
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

    if ($IsWindows -and -not (Get-Command $config.command -CommandType Application -ErrorAction Ignore)) {
        $pkgRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
        if (Test-Path $pkgRoot) {
            $exe = Get-ChildPath $pkgRoot -File -Filter "$($config.command).exe" -Depth 5 -Exclude @() -PruneVendor $false |
                Select-Object -First 1
            $exeDirectory = if ($exe) {
                [System.IO.Path]::GetDirectoryName($exe)
            }
            if ($exe -and (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains $exeDirectory)) {
                $env:PATH = "$exeDirectory$([System.IO.Path]::PathSeparator)$env:PATH"
                Write-Message "Session PATH: prepended '$exeDirectory' so $($config.command) resolves (no WinGet\Links symlink)"
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
