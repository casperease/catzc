<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Uninstall-Tool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
---
#>

<#
.SYNOPSIS
    Uninstalls a tool using the platform package manager.
.DESCRIPTION
    A tool that is missing or not functional is a no-op, not an error, so the call is safe to repeat.
    [comment:1](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER Version
    Version override. Defaults to the locked version.
#>
function Uninstall-Tool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,

        [string] $Version
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool

    # Redirect to the npm remover now, rather than fail later on a winget id that this tool does not have.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment2)
    if ($config.npm_package) {
        throw "$Tool is an npm-managed tool. Uninstall-Tool manages winget/brew/apt packages only — use Uninstall-$command (npm) instead."
    }

    # Idempotent: skip if not installed or not functional (e.g., Windows Store stub)
    if (-not (Test-Tool $Tool -SkipVersionCheck)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    # A locked version that differs from the installed major makes a versioned winget id name a package that is absent.
    # [comment:3](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment3)
    if (-not $Version) {
        $installed = Get-ToolVersion -Config $config
        $components = ($config.version -split '\.').Count
        $Version = (($installed -split '\.') | Select-Object -First $components) -join '.'
    }

    # An install made outside our package manager is refused here and left to its Remove command.
    # [comment:4](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment4)
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

        # Only a before-and-after diff shows what the uninstaller removed; Test-Path cannot tell stale from live.
        # [comment:5](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment5)
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

        # Terraform-style uninstallers delete the directory but leave its registry PATH entry, so prune by existence.
        # [comment:6](/docs/references/automation/catzc-tooling-core/Uninstall-Tool.ps1.md#comment6)
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
