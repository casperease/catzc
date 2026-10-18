# automation/Catzc.Tooling.Python/Install-PySpark.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs PySpark into the uv-managed Python via `uv pip`.

### description

Installs pyspark with `uv pip install --system` so it is importable in the uv-managed Python. Requires uv
and Python (depends_on python for install ordering). Java is a runtime dependency — Invoke-PySpark asserts
it before PySpark is used.

### parameter Version

PySpark version to install. Defaults to the locked version in Get-ToolConfig.

### parameter Force

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-PySpark
```

### example 2

```powershell
Install-PySpark -Version '3.5'
```
