---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md
    kind: comment-page
    body_sha: d7d0fa60aa3a
---

# automation/Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Uninstalls tools in reverse dependency order (derived from depends_on
in tools.yml). Tools that depend on others are removed first so their
uninstallers can still use the dependency (e.g., az_cli is removed
before uv). OS-provided prerequisites (winget) are never uninstalled,
and Windows-only tools are skipped off Windows. Idempotent — skips
tools that are not installed.
```

## comment:2

Above `$order = @(Get-ToolInstallOrder)`.

```text
Version-locked tools in reverse dependency order. @() guards the empty/null case: [array]::Reverse
throws on $null, and a single-element result would otherwise unwrap to a scalar (not an array).
```

## comment:3

Above `if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {`.

```text
Elevation-bound tools (admin_only machine-scope, or apt-get-routed Linux installs) need the same
elevation to uninstall — skip and report in a non-elevated run.
```

## comment:4

Above `$uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"`.

```text
Map the snake_case tools.yml key to its PascalCase command suffix, exactly as Install-DevBoxTools does
(node_js -> Uninstall-NodeJs, az_cli -> Uninstall-AzCli, py_spark -> Uninstall-PySpark). Building
"Uninstall-$toolName" from the raw key only works for single-word tools by PowerShell's case-insensitive
command resolution; a multi-word key ("node_js") never resolves to its function ("Uninstall-NodeJs") and
was silently skipped. Throw on a missing uninstaller, mirroring Install-DevBoxTools — a locked tool must
have one, so its absence is a defect to surface, not a tool to skip.
```

## comment:5

Above `$order = @(Get-ToolInstallOrder)`.

```text
Version-locked tools in reverse dependency order. @() guards the empty/null case: [array]::Reverse
throws on $null, and a single-element result would otherwise unwrap to a scalar (not an array).
```

## comment:6

Above `if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {`.

```text
Elevation-bound tools (admin_only machine-scope, or apt-get-routed Linux installs) need the same
elevation to uninstall — skip and report in a non-elevated run.
```

## comment:7

Above `$uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"`.

```text
Map the snake_case tools.yml key to its PascalCase command suffix, exactly as Install-DevBoxTools does
(node_js -> Uninstall-NodeJs, az_cli -> Uninstall-AzCli, py_spark -> Uninstall-PySpark). Building
"Uninstall-$toolName" from the raw key only works for single-word tools by PowerShell's case-insensitive
command resolution; a multi-word key ("node_js") never resolves to its function ("Uninstall-NodeJs") and
was silently skipped. Throw on a missing uninstaller, mirroring Install-DevBoxTools — a locked tool must
have one, so its absence is a defect to surface, not a tool to skip.
```
