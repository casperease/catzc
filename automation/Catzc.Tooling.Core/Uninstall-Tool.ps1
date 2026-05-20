<#
.SYNOPSIS
    Uninstalls a tool using the platform package manager.
.DESCRIPTION
    Uses winget on Windows, brew on macOS, and apt-get on Linux.
    Skips if the tool is not installed.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER Version
    Version override. Defaults to the locked version.
#>
function Uninstall-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool,

        [string] $Version
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool
    if (-not $Version) {
        $Version = $config.version
    }

    # Idempotent: skip if not installed or not functional (e.g., Windows Store stub)
    if (-not (Test-Tool $Tool -SkipVersionCheck)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    # Only uninstall tools managed by the expected package manager.
    # Use Remove-<Tool> for tools installed outside our control.
    if (-not (Test-ExpectedPackageManager -Config $config)) {
        $location = (Get-Command $config.command).Source
        throw "$Tool at '$location' was not installed by the expected package manager. Use Remove-$command to handle it."
    }

    if ($IsWindows) {
        Assert-NotNullOrWhitespace $config.winget_id -ErrorText "$Tool has no WingetId — use Uninstall-$command directly"
        if ($config.winget_scope -ne 'user') {
            Assert-IsAdministrator -ErrorText "Uninstall-$command on Windows requires Administrator (winget machine-scope). Run as Administrator or uninstall $Tool manually."
        }
        Assert-Command winget
        $packageId = $config.winget_id -f $Version

        # Snapshot User PATH before uninstall so we can detect what the
        # uninstaller removes. Winget uninstallers often remove their registry
        # PATH entries but leave directories on disk — Test-Path alone can't
        # tell stale from legitimate.
        $beforeEntries = [System.Collections.Generic.HashSet[string]]::new(
            [string[]]((Get-EnvironmentPath -Scope User) -split ';' |
                    Where-Object { $_ -ne '' } |
                    ForEach-Object { $_.TrimEnd('\', '/') }),
            [System.StringComparer]::OrdinalIgnoreCase
        )

        Invoke-Executable "winget uninstall --id $packageId --silent"

        # Find entries the uninstaller removed from the registry
        $afterEntries = [System.Collections.Generic.HashSet[string]]::new(
            [string[]]((Get-EnvironmentPath -Scope User) -split ';' |
                    Where-Object { $_ -ne '' } |
                    ForEach-Object { $_.TrimEnd('\', '/') }),
            [System.StringComparer]::OrdinalIgnoreCase
        )
        $removed = [System.Collections.Generic.HashSet[string]]::new($beforeEntries, [System.StringComparer]::OrdinalIgnoreCase)
        $removed.ExceptWith($afterEntries)

        # Remove those entries from the session PATH too
        if ($removed.Count -gt 0) {
            $env:PATH = ($env:PATH -split ';' |
                    Where-Object { $_ -eq '' -or -not $removed.Contains($_.TrimEnd('\', '/')) }) -join ';'
        }

        # Some uninstallers remove the directory but leave the PATH entry in
        # the registry (e.g. Terraform). Clean those by checking existence.
        $userPath = Get-EnvironmentPath -Scope User
        if ($userPath) {
            $cleaned = ($userPath -split ';' |
                    Where-Object { $_ -eq '' -or (Test-Path $_) }) -join ';'
            if ($cleaned -ne $userPath) {
                Set-EnvironmentPath $cleaned -Scope User
            }
        }
        $env:PATH = ($env:PATH -split ';' |
                Where-Object { $_ -eq '' -or (Test-Path $_) }) -join ';'
    }
    elseif ($IsMacOS) {
        Assert-NotNullOrWhitespace $config.brew_formula -ErrorText "$Tool has no BrewFormula — use Uninstall-$command directly"
        Assert-Command brew
        $formula = $config.brew_formula -f $Version
        Invoke-Executable "brew uninstall $formula"
    }
    elseif ($IsLinux) {
        Assert-NotNullOrWhitespace $config.apt_package -ErrorText "$Tool has no AptPackage — use Uninstall-$command directly"
        Assert-IsAdministrator -ErrorText "Uninstall-$command on Linux requires root (apt-get). Run as root or uninstall $Tool manually."
        Assert-Command apt-get
        $package = $config.apt_package -f $Version
        Invoke-Executable "sudo apt-get remove -y $package"
    }
    else {
        throw 'Unsupported platform for tool uninstallation'
    }

    Write-Message "$Tool $Version uninstalled"
}
