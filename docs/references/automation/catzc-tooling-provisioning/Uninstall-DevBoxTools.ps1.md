---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-DevBoxTools.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "255c52fcf955"
---

# automation/Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$order = @(Get-ToolInstallOrder)`, written with `#`.

```text
Version-locked tools in reverse dependency order. @() guards the empty/null case: [array]::Reverse
throws on $null, and a single-element result would otherwise unwrap to a scalar (not an array).
```

## comment:2

Above `if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {`, written with `#`.

```text
Elevation-bound tools (admin_only machine-scope, or apt-get-routed Linux installs) need the same
elevation to uninstall — skip and report in a non-elevated run.
```

## comment:3

Above `$uninstallCmd = "Uninstall-$(Get-ToolCommandSuffix -Tool $toolName)"`, written with `#`.

```text
Map the snake_case tools.yml key to its PascalCase command suffix, exactly as Install-DevBoxTools does
(node_js -> Uninstall-NodeJs, az_cli -> Uninstall-AzCli, py_spark -> Uninstall-PySpark). Building
"Uninstall-$toolName" from the raw key only works for single-word tools by PowerShell's case-insensitive
command resolution; a multi-word key ("node_js") never resolves to its function ("Uninstall-NodeJs") and
was silently skipped. Throw on a missing uninstaller, mirroring Install-DevBoxTools — a locked tool must
have one, so its absence is a defect to surface, not a tool to skip.
```
