<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md"
  warning: "Generated Header"
---
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

    if ($Config.uv_python) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable 'uv python list --only-installed --managed-python' -PassThru -NoAssert -Silent
        return [bool]$result.Output
    }

    if ($IsWindows -and $Config.winget_id) {
        if (-not (Test-Command winget)) {
            return $false
        }

        $baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')

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

    if ($Config.msys2_url) {
        return [bool](Test-Command $Config.command)
    }

    $false
}
