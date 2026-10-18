# automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Poetry.

### description

Removes the uv-managed install (`uv tool uninstall poetry`) via Uninstall-UvTool. Idempotent — skips if
Poetry is not installed.

### example 1

```powershell
Uninstall-Poetry
```
