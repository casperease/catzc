<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Test-ExpectedPackageManager.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs:
      - ADR-AUTO-REMOVE#3
---
#>

<#
.SYNOPSIS
    Tests whether a tool is managed by the expected package manager.
.DESCRIPTION
    Check order decides who judges: an MSYS2 tool that also declares apt_package is judged by apt on Linux.
    [comment:1](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment1)
.PARAMETER Config
    Tool configuration hashtable from Get-ToolConfig / tools.yml.
.PARAMETER WingetListCache
    Pre-fetched winget list output (Get-WingetListCache), so a batch of checks lists once.
    A batch of checks lists winget once and passes the result here, not one winget call per tool.
    [comment:3](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment3)
.PARAMETER Path
    A removal passes the folder it will delete, so the managed install's PATH position never judges another folder.
    [comment:2](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment2)
    The default is the PATH-resolved folder, always the managed install in a catzc session, so removals pass this.
    [comment:4](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment4)
#>
function Test-ExpectedPackageManager {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config,

        [string] $WingetListCache,

        [string] $Path
    )

    # 0. OS-provided tools (winget) — the OS is the manager, so "managed" means simply present.
    if ($Config.system_provided) {
        return [bool](Test-Command $Config.command)
    }

    # Judged by folder, not by a package manager: script installs and Windows MSYS2 trees have none to ask.
    # [comment:5](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment5)
    if ($Config.script_install -or ($Config.msys2_url -and $IsWindows)) {
        $expectedDir = [System.IO.Path]::GetFullPath((Get-ScriptInstallDir -Config $Config)).TrimEnd('\', '/')
        if ($Path) {
            $target = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
            return $target -ieq $expectedDir -or $target -like "$expectedDir$([System.IO.Path]::DirectorySeparatorChar)*"
        }
        if (-not (Test-Command $Config.command)) {
            return $false
        }
        $location = (Get-Command $Config.command).Source
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

    # uv-venv tools (az_cli) — managed when the command resolves from under the toolchain's venv root.
    if ($Config.uv_venv) {
        if (-not (Test-Command $Config.command)) {
            return $false
        }
        $venvRoot = if ($IsWindows) {
            Join-Path $env:LOCALAPPDATA 'catzc\venvs'
        }
        else {
            Join-Path $HOME '.local/share/catzc/venvs'
        }
        return (Get-Command $Config.command).Source -like "$venvRoot*"
    }

    # Managed-only listing leaves out system pythons uv merely discovered, which would falsely count as managed.
    # [comment:6](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment6)
    if ($Config.uv_python) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable 'uv python list --only-installed --managed-python' -PassThru -NoAssert -Silent
        return [bool]$result.Output
    }

    # A platform manager counts only when the tool declares its field for this platform, else the check falls through.
    # [comment:7](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment7)
    if ($IsWindows -and $Config.winget_id) {
        if (-not (Test-Command winget)) {
            return $false
        }

        # Dropping the version placeholder lets the search match any installed version, not only the locked one.
        # [comment:8](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment8)
        $baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')

        # A version hardcoded as the last ID segment, such as DotNet.SDK.10, is stripped for the same any-version match.
        # [comment:9](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment9)
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

    # Library packages live in the uv-managed Python, which show --system inspects without importing the package.
    # [comment:10](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment10)
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

    # With no manager declared for this platform, such as zsh on macOS, the OS is the manager: present means managed.
    # [comment:11](/docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md#comment11)
    if ($Config.msys2_url) {
        return [bool](Test-Command $Config.command)
    }

    $false
}
