<#
.SYNOPSIS
    Tests whether a tool is managed by the expected package manager.
.DESCRIPTION
    Checks the platform's expected package manager to determine if it
    currently manages the given tool. Check order: UserInstallDir (script-
    installed), platform-specific (winget/brew/apt), then pip (cross-
    platform fallback). Returns $false if the manager is not available.
.PARAMETER Config
    Tool configuration hashtable from Get-ToolConfig / tools.yml.
#>
function Test-ExpectedPackageManager {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config,

        # Pre-fetched winget list output. When provided, skips the per-tool
        # winget list call — pass the result of Get-WingetListCache.
        [string] $WingetListCache
    )

    # 1. Script-installed tools (e.g., Dotnet via dotnet-install scripts).
    if ($Config.script_install) {
        if (-not (Test-Command $Config.command)) {
            return $false
        }
        $location = (Get-Command $Config.command).Source
        $expectedDir = Get-ScriptInstallDir -Config $Config
        return $location -like "$expectedDir*"
    }

    # 2. uv-managed tools (az_cli, poetry) — cross-platform, installed in isolated uv environments.
    if ($Config.uv_tool) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable 'uv tool list' -PassThru -NoAssert -Silent
        return $result.Full -match [regex]::Escape($Config.uv_tool)
    }

    # uv-provisioned Python — managed only when uv reports an installed uv-MANAGED CPython. --managed-python
    # excludes system pythons uv merely discovered (e.g. a winget/system 3.11), which would false-positive.
    if ($Config.uv_python) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable 'uv python list --only-installed --managed-python' -PassThru -NoAssert -Silent
        return [bool]$result.Output
    }

    # 3. Platform-specific package managers — only if the tool has the field
    #    for the current platform.
    if ($IsWindows -and $Config.winget_id) {
        if (-not (Test-Command winget)) {
            return $false
        }

        # Build a search prefix that matches any version of this tool.
        # Format-string IDs like "Python.Python.{0}" become "Python.Python".
        $baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')

        # For IDs without a format placeholder the version may be hardcoded
        # as the last segment (e.g., Microsoft.DotNet.SDK.10). Strip it so
        # the search finds any installed version, not just the locked one.
        if ($Config.winget_id -notmatch '\{0\}') {
            $parts = $baseId -split '\.'
            if ($parts.Count -gt 2 -and $parts[-1] -match '^\d') {
                $baseId = $parts[0..($parts.Count - 2)] -join '.'
            }
        }

        # Use pre-fetched cache when available (single winget list call for all tools).
        if ($WingetListCache) {
            return $WingetListCache -match [regex]::Escape($baseId)
        }

        $result = Invoke-Executable "winget list --id $baseId --accept-source-agreements --disable-interactivity" -PassThru -NoAssert -Silent
        return $result.Full -match [regex]::Escape($baseId)
    }

    if ($IsMacOS -and $Config.brew_formula) {
        if (-not (Test-Command brew)) {
            return $false
        }
        $formula = ($Config.brew_formula -replace '\{0\}', '').TrimEnd('@', '-')
        $result = Invoke-Executable "brew list $formula" -PassThru -NoAssert -Silent
        return $result.ExitCode -eq 0
    }

    if ($IsLinux -and $Config.apt_package) {
        if (-not (Test-Command dpkg)) {
            return $false
        }
        $package = ($Config.apt_package -replace '\{0\}', '').TrimEnd('-')
        $result = Invoke-Executable "dpkg -s $package" -PassThru -NoAssert -Silent
        return $result.ExitCode -eq 0
    }

    # 3. uv pip — library packages installed into the uv-managed Python (e.g. pyspark). `uv pip show --system`
    #    inspects the global interpreter without importing the package.
    if ($Config.pip_package) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable "uv pip show --system $($Config.pip_package)" -PassThru -NoAssert -Silent
        return [bool]$result.Output
    }

    # 4. npm — cross-platform global packages (e.g., cspell).
    if ($Config.npm_package) {
        if (-not (Test-Command npm)) {
            return $false
        }
        $result = Invoke-Executable "npm ls -g $($Config.npm_package)" -PassThru -NoAssert -Silent
        return $result.ExitCode -eq 0
    }

    $false
}
