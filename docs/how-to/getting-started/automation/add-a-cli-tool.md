# Add a CLI tool

System CLI tools (Python, .NET, Azure CLI, Terraform, …) are version-locked in one config file and installed by a generic, platform-aware
engine. Adding or upgrading a tool is a config change, not new install code. The reasoning is in
[controlling-systemwide-deps](../../../adr/automation/controlling-systemwide-deps.md) and
[use-proper-package-managers](../../../adr/automation/use-proper-package-managers.md).

## The model

`automation/Catzc.Tooling.Core/configs/tools.yml` is the source of truth. Each entry is keyed by a snake_case tool name and carries the
version plus the install metadata each platform needs. The generic engine in `Catzc.Tooling.Core` (`Install-Tool`, `Uninstall-Tool`,
`Assert-Tool`, `Get-ToolConfig`, `Get-ToolInstallOrder`) reads the config and picks the right package manager: winget on Windows, brew on
macOS, apt on Linux, pip as a cross-platform fallback.

```yaml
# automation/Catzc.Tooling.Core/configs/tools.yml
python:
  version: "3.11"
  command: python
  winget_id: "Python.Python.{0}"
  winget_scope: user
  brew_formula: "python@{0}"
  apt_package: "python{0}"
  version_command: "python --version"
  version_pattern: "^Python (?<ver>.+)$"
```

`{0}` is substituted with the version; `(?<ver>…)` captures the installed version so `Assert-Tool` can compare it to the lock.

## Upgrade a tool

Change `version` in `tools.yml` and open a PR. That single line propagates to every function that reads the config and to CI — no call sites
change.

```powershell
. ./importer.ps1
Install-Python -Force      # replace a wrong version with the locked one
Get-ToolsStatus            # OK / Usable / WrongVersion / Missing / Unwanted per tool
```

## Add a new tool

Most tools need only a config entry plus the three convention functions:

1. **Add the entry** to `tools.yml` with `version`, `command`, `version_command`, `version_pattern`, and the platform install keys
   (`winget_id` / `brew_formula` / `apt_package`, or `pip_package` with `depends_on: python`, or `script_install: true` with
   `windows_install_dir` / `unix_install_dir`). If it must install after another tool, add `depends_on: <tool>` — `Get-ToolInstallOrder`
   topologically sorts installs.
2. **Add the triad** in the matching ecosystem module — `Catzc.Tooling.Python` for pip tools, `Catzc.Tooling.Node` for npm tools,
   `Catzc.Tooling.Toolchain` for generic package-manager / script tools (one function per file), each delegating to the engine:
   - `Install-<Tool>` — installs the locked version, idempotent, `-Force` replaces a wrong version. For a pip tool, delegate to
     `Install-PipTool` (a private helper in `Catzc.Tooling.Python`); otherwise to `Install-Tool`.
   - `Invoke-<Tool>` — asserts presence + version (cached per session), then runs the tool. Forward the `Invoke-Executable` switches
     `-PassThru` / `-NoAssert` / `-Silent` / `-DryRun`.
   - `Uninstall-<Tool>` — removes the managed install via the same manager. Add `Remove-<Tool>` if you also need to hard- remove an
     unmanaged install (delete the directory, clean PATH).
3. **Wire it into provisioning** if it belongs in the standard devbox: `Install-DevBoxTools` (in `Catzc.Tooling.Provisioning`) installs
   everything in dependency order.

## Invoke pattern

```powershell
Invoke-Python '--version'
$r = Invoke-AzCli 'account show' -PassThru -NoAssert -Silent   # probe without throwing on non-zero exit
if ($r.ExitCode -eq 0) { $account = $r.Output | ConvertFrom-Json }
```

`Invoke-<Tool>` asserts the right version before running, so a script never silently uses the wrong toolchain. Each invocation logs the
exact command first (see [log-before-invoke](../../../adr/automation/log-before-invoke.md)).

## Why not Chocolatey, why not Az modules

Windows installs use **winget** (hash-verified, mandatory review), never Chocolatey — `Install-DevBoxTools` even removes Chocolatey first
(see [use-proper-package-managers](../../../adr/automation/use-proper-package-managers.md)). Azure work uses the **`az` CLI**, not the Az
PowerShell modules, to avoid assembly conflicts and slow imports (see [prefer-az-cli](../../../adr/automation/prefer-az-cli.md)). To log in,
use `Connect-AzCli`.

## Verify

```powershell
. ./importer.ps1
Get-ToolsStatus
Assert-DevBoxToolsStatus    # throws with remediation hints if any tool is Missing/WrongVersion/Unwanted
```
