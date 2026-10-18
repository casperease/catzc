# pwsh/Catzc.Tooling.Provisioning/Uninstall-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the Postman desktop app.

### description

Windows: Removes LOCALAPPDATA\Postman directory. macOS: brew uninstall --cask postman. Linux: Removes HOME/.local/Postman directory.
Idempotent — skips if not installed.

### example 1

```powershell
Uninstall-Postman
```
