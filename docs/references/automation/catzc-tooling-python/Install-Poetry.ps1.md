# docs/references/automation/catzc-tooling-python/Install-Poetry.ps1.md

`automation/Catzc.Tooling.Python/Install-Poetry.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Installs Poetry user-space via uv (`uv tool install poetry`) in its own environment. Requires uv.
Idempotent — skips if the correct version is already on PATH.
```
