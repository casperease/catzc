# pwsh/Tooling.Core/Test-ExpectedPackageManager.ps1

The check that a tool is managed by the package manager the platform expects. It walks the managers in a fixed order and answers at the
first that applies; the removers use it to tell a managed install from an off-config one.

## help

### synopsis

Tests whether a tool is managed by the expected package manager.

### description

Checks the platform's expected package manager to determine if it currently manages the given tool. Check order: system-provided,
UserInstallDir (script-installed, and an MSYS2-package tool's tree on Windows), uv, platform-specific (winget/brew/apt), pip and npm
(cross-platform fallbacks), then an MSYS2-package tool that declares no manager for this platform, which is the system's. So an
MSYS2-package tool that also declares an apt_package is judged by apt on Linux. Returns $false if the manager is not available.

### parameter `Config`

Tool configuration hashtable from Get-ToolConfig / tools.yml.

### parameter `WingetListCache`

Pre-fetched winget list output (Get-WingetListCache), so a batch of checks lists once. Pre-fetched winget list output. When provided, skips
the per-tool winget list call — pass the result of Get-WingetListCache.

### parameter `Path`

For a script-installed tool, or an MSYS2-package tool on Windows: judge this install folder (or a file in it) instead of the one the command
resolves to on PATH. A removal names the folder it is about to delete, so the managed install's position on PATH never decides whether a
different folder is managed
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)). The
install folder to judge, for a script-installed or an MSYS2-package tool. Default: the folder the command resolves to on PATH — which, in a
catzc session, is always the managed install, so a removal of another folder names it.

## Script-installed tools

A script-installed tool, such as dotnet through the dotnet-install scripts, is managed when it sits inside its install folder. On Windows an
MSYS2-package tool is judged the same way, against the tree `Get-ScriptInstallDir` names as its `windows_install_dir`.

## uv-provisioned Python

Python is managed only when uv reports an installed uv-managed CPython. `--managed-python` excludes the system Pythons uv merely discovered,
such as a winget or system 3.11, which would otherwise be false positives.

## Platform package managers

winget, brew and apt are consulted only when the tool declares the field for the current platform. For winget the check builds a search
prefix that matches any version of the tool: a format-string id such as `Python.Python.{0}` becomes `Python.Python`. An id without a
placeholder may carry the version as its last segment, such as `Microsoft.DotNet.SDK.10`, so that segment is stripped and the search finds
any installed version, not only the locked one.

## pip

A library package installed into the uv-managed Python, such as pyspark, is checked with `uv pip show --system`, which inspects the global
interpreter without importing the package.

## MSYS2 packages off Windows

An MSYS2-package tool off Windows with no manager declared for the platform, such as zsh on macOS, is the system's. "Managed" then means
simply present, as for an OS-provided tool.
