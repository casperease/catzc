<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md"
  header: "generated"
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

    # Script-installed and, on Windows, MSYS2-package tools install into the tree Get-ScriptInstallDir names, and are managed only inside it.
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

    # --managed-python excludes system pythons uv merely discovered (a winget 3.11, say), which would false-positive.
    if ($Config.uv_python) {
        if (-not (Test-Command uv)) {
            return $false
        }
        $result = Invoke-Executable 'uv python list --only-installed --managed-python' -PassThru -NoAssert -Silent
        return [bool]$result.Output
    }

    # A platform package manager counts only when the tool declares the field for the current platform.
    if ($IsWindows -and $Config.winget_id) {
        if (-not (Test-Command winget)) {
            return $false
        }

        # The search prefix matches any version of the tool: a format-string id like Python.Python.{0} becomes Python.Python.
        $baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')

        # An id without a placeholder may carry a hardcoded version as its last segment (Microsoft.DotNet.SDK.10), stripped so any installed version is found.
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

    # uv pip show --system inspects the global interpreter without importing the package.
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

    # An MSYS2-package tool off Windows with no manager declared (zsh on macOS) is the system's, so managed means simply present.
    if ($Config.msys2_url) {
        return [bool](Test-Command $Config.command)
    }

    $false
}
