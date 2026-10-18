# automation/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls uv.

### description

Removes the managed install via the platform package manager: winget (Windows) or brew (macOS). Delegates to Uninstall-Tool. Idempotent —
skips if not installed.

### parameter Version

uv version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Uv
```
