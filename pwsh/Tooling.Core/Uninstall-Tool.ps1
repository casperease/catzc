function Uninstall-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,

        [string] $Version
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool

    # An npm-managed tool is redirected to Uninstall-$command, instead of failing later on a missing winget id.
    if ($config.npm_package) {
        throw "$Tool is an npm-managed tool. Uninstall-Tool manages winget/brew/apt packages only — use Uninstall-$command (npm) instead."
    }

    # Idempotent: skip if not installed or not functional (e.g., Windows Store stub)
    if (-not (Test-Tool $Tool -SkipVersionCheck)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    # The installed version is removed, not the locked one, reduced to the locked granularity so an id's {0} placeholder matches the installed package (node 22.22.2 to 22).
    if (-not $Version) {
        $installed = Get-ToolVersion -Config $config
        $components = ($config.version -split '\.').Count
        $Version = (($installed -split '\.') | Select-Object -First $components) -join '.'
    }

    # Only a tool the expected package manager owns is uninstalled here; one installed outside our control goes through Remove-<Tool>.
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

        # The User PATH snapshot tells what the uninstaller removed, since winget uninstallers often drop the registry entry but leave the directory on disk.
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
        $removed = [System.Collections.Generic.HashSet[string]]::new($beforeEntries,
            [System.StringComparer]::OrdinalIgnoreCase)
        $removed.ExceptWith($afterEntries)

        # Remove those entries from the session PATH too
        if ($removed.Count -gt 0) {
            $env:PATH = ($env:PATH -split ';' |
                    Where-Object { $_ -eq '' -or -not $removed.Contains($_.TrimEnd('\', '/')) }) -join ';'
        }

        # Some uninstallers (Terraform) remove the directory but leave the PATH entry, so an entry whose directory is gone is cleaned.
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
