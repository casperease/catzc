# pwsh/Tooling.Python/Uninstall-PySpark.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls PySpark from the uv-managed Python via `uv pip`.

### description

Idempotent — skips if PySpark is not installed or if Python is not available (nothing to uninstall).

### example 1

```powershell
Uninstall-PySpark
```
