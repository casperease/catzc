---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md
    kind: comment-page
    body_sha: bc74efa62d11
    adrs:
      - ADR-AUTO-REMOVE#3
---

# automation/Catzc.Tooling.Core/Test-ExpectedPackageManager.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks the platform's expected package manager to determine if it
currently manages the given tool. Check order: system-provided, UserInstallDir (script-installed, and an
MSYS2-package tool's tree on Windows), uv, platform-specific (winget/brew/apt), pip and npm (cross-platform
fallbacks), then an MSYS2-package tool that declares no manager for this platform, which is the system's. So an
MSYS2-package tool that also declares an apt_package is judged by apt on Linux. Returns $false if the manager is
not available.
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
For a script-installed tool, or an MSYS2-package tool on Windows: judge this install folder (or a file in it)
instead of the one the command resolves to on PATH. A removal names the folder it is about to delete, so the managed install's position on PATH never decides
whether a different folder is managed
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:3

Above `[string] $WingetListCache,`.

```text
Pre-fetched winget list output. When provided, skips the per-tool
winget list call — pass the result of Get-WingetListCache.
```

## comment:4

Above `[string] $Path`.

```text
The install folder to judge, for a script-installed or an MSYS2-package tool. Default: the folder the command resolves to on
PATH — which, in a catzc session, is always the managed install, so a removal of another folder names it.
```

## comment:5

Above `if ($Config.script_install -or ($Config.msys2_url -and $IsWindows)) {`.

```text
1. Script-installed tools (e.g., Dotnet via dotnet-install scripts), and on Windows MSYS2-package tools, which
   install into the tree Get-ScriptInstallDir names (windows_install_dir): managed when inside that folder.
```

## comment:6

Above `if ($Config.uv_python) {`.

```text
uv-provisioned Python — managed only when uv reports an installed uv-MANAGED CPython. --managed-python
excludes system pythons uv merely discovered (e.g. a winget/system 3.11), which would false-positive.
```

## comment:7

Above `if ($IsWindows -and $Config.winget_id) {`.

```text
3. Platform-specific package managers — only if the tool has the field
   for the current platform.
```

## comment:8

Above `$baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')`.

```text
Build a search prefix that matches any version of this tool.
Format-string IDs like "Python.Python.{0}" become "Python.Python".
```

## comment:9

Above `if ($Config.winget_id -notmatch '\{0\}') {`.

```text
For IDs without a format placeholder the version may be hardcoded
as the last segment (e.g., Microsoft.DotNet.SDK.10). Strip it so
the search finds any installed version, not just the locked one.
```

## comment:10

Above `if ($Config.pip_package) {`.

```text
3. uv pip — library packages installed into the uv-managed Python (e.g. pyspark). `uv pip show --system`
   inspects the global interpreter without importing the package.
```

## comment:11

Above `if ($Config.msys2_url) {`.

```text
5. An MSYS2-package tool off Windows with no manager declared for this platform (zsh on macOS) is the system's,
   so "managed" means simply present, as for an OS-provided tool.
```

## comment:12

Above `if ($Config.script_install -or ($Config.msys2_url -and $IsWindows)) {`.

```text
1. Script-installed tools (e.g., Dotnet via dotnet-install scripts), and on Windows MSYS2-package tools, which
   install into the tree Get-ScriptInstallDir names (windows_install_dir): managed when inside that folder.
```

## comment:13

Above `if ($Config.uv_python) {`.

```text
uv-provisioned Python — managed only when uv reports an installed uv-MANAGED CPython. --managed-python
excludes system pythons uv merely discovered (e.g. a winget/system 3.11), which would false-positive.
```

## comment:14

Above `if ($IsWindows -and $Config.winget_id) {`.

```text
3. Platform-specific package managers — only if the tool has the field
   for the current platform.
```

## comment:15

Above `$baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')`.

```text
Build a search prefix that matches any version of this tool.
Format-string IDs like "Python.Python.{0}" become "Python.Python".
```

## comment:16

Above `if ($Config.winget_id -notmatch '\{0\}') {`.

```text
For IDs without a format placeholder the version may be hardcoded
as the last segment (e.g., Microsoft.DotNet.SDK.10). Strip it so
the search finds any installed version, not just the locked one.
```

## comment:17

Above `if ($Config.pip_package) {`.

```text
3. uv pip — library packages installed into the uv-managed Python (e.g. pyspark). `uv pip show --system`
   inspects the global interpreter without importing the package.
```

## comment:18

Above `if ($Config.msys2_url) {`.

```text
5. An MSYS2-package tool off Windows with no manager declared for this platform (zsh on macOS) is the system's,
   so "managed" means simply present, as for an OS-provided tool.
```
