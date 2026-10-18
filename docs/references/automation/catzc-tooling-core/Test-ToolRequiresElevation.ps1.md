# automation/Catzc.Tooling.Core/Test-ToolRequiresElevation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether installing (or uninstalling) a tool on the current platform requires elevation.

### description

Answers the per-platform elevation question the provisioning loops skip-and-report on. A tool is elevation-bound when its tools.yml entry
declares admin_only (a machine-scope installer on every platform, e.g. Microsoft.OpenJDK), or linux_admin_only while the session runs on
Linux (the tool installs through apt-get, which needs root, while its Windows and macOS installs are user-space — node_js and terraform are
this shape). Pure logic over the entry and the platform: it asks about the install path, never about whether the tool is present.

### parameter Config

The tool's parsed tools.yml entry (from Get-ToolConfig).

### outputs

`[bool]`

### example 1

```powershell
Test-ToolRequiresElevation (Get-ToolConfig -Tool node_js)
```
