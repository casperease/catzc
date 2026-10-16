---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-ExpectedPackageManager.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6e24a1615476"
---

# automation/Catzc.Tooling.Core/Test-ExpectedPackageManager.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Config.script_install -or ($Config.msys2_url -and $IsWindows)) {`, written with `#`.

```text
1. Script-installed tools (e.g., Dotnet via dotnet-install scripts), and on Windows MSYS2-package tools, which
   install into the tree Get-ScriptInstallDir names (windows_install_dir): managed when inside that folder.
```

## comment:2

Above `if ($Config.uv_python) {`, written with `#`.

```text
uv-provisioned Python — managed only when uv reports an installed uv-MANAGED CPython. --managed-python
excludes system pythons uv merely discovered (e.g. a winget/system 3.11), which would false-positive.
```

## comment:3

Above `if ($IsWindows -and $Config.winget_id) {`, written with `#`.

```text
3. Platform-specific package managers — only if the tool has the field
   for the current platform.
```

## comment:4

Above `$baseId = ($Config.winget_id -replace '\{0\}', '').TrimEnd('.', '-')`, written with `#`.

```text
Build a search prefix that matches any version of this tool.
Format-string IDs like "Python.Python.{0}" become "Python.Python".
```

## comment:5

Above `if ($Config.winget_id -notmatch '\{0\}') {`, written with `#`.

```text
For IDs without a format placeholder the version may be hardcoded
as the last segment (e.g., Microsoft.DotNet.SDK.10). Strip it so
the search finds any installed version, not just the locked one.
```

## comment:6

Above `if ($Config.pip_package) {`, written with `#`.

```text
3. uv pip — library packages installed into the uv-managed Python (e.g. pyspark). `uv pip show --system`
   inspects the global interpreter without importing the package.
```

## comment:7

Above `if ($Config.msys2_url) {`, written with `#`.

```text
5. An MSYS2-package tool off Windows with no manager declared for this platform (zsh on macOS) is the system's,
   so "managed" means simply present, as for an OS-provided tool.
```
