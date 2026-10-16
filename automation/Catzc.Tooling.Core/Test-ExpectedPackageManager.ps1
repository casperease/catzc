<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/Test-ExpectedPackageManager.ps1
    name: test-expected-package-manager
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md
    test: automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
    cites:
      - ADR-AUTO-REMOVE#3
  config:
    synopsis: Tests whether a tool is managed by the expected package manager.
    description: |-
      Checks the platform's expected package manager to determine if it
      currently manages the given tool. Check order: system-provided, UserInstallDir (script-installed, and an
      MSYS2-package tool's tree on Windows), uv, platform-specific (winget/brew/apt), pip and npm (cross-platform
      fallbacks), then an MSYS2-package tool that declares no manager for this platform, which is the system's. So an
      MSYS2-package tool that also declares an apt_package is judged by apt on Linux. Returns $false if the manager is
      not available.
    parameters:
      Config: Tool configuration hashtable from Get-ToolConfig / tools.yml.
      WingetListCache: |-
        Pre-fetched winget list output (Get-WingetListCache), so a batch of checks lists once.
        Pre-fetched winget list output. When provided, skips the per-tool
        winget list call — pass the result of Get-WingetListCache.
      Path: |-
        For a script-installed tool, or an MSYS2-package tool on Windows: judge this install folder (or a file in it)
        instead of the one the command resolves to on PATH. A removal names the folder it is about to delete, so the
        managed install's position on PATH never decides whether a different folder is managed
        ([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
        The install folder to judge, for a script-installed or an MSYS2-package tool. Default: the folder the command
        resolves to on PATH — which, in a catzc session, is always the managed install, so a removal of another folder names it.
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
