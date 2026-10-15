# docs/references/automation/catzc-tooling-python/Install-PySpark.ps1.md

`automation/Catzc.Tooling.Python/Install-PySpark.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Installs pyspark with `uv pip install --system` so it is importable in the uv-managed Python. Requires uv
and Python (depends_on python for install ordering). Java is a runtime dependency — Invoke-PySpark asserts
it before PySpark is used.
```
