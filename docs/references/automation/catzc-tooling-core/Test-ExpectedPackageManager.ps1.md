---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md
    kind: comment-page
    body_sha: dc741ea7e23c
---

# automation/Catzc.Tooling.Core/Test-ExpectedPackageManager.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
