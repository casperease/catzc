# docs/references/automation/catzc-tooling-core/private/Get-UvVenvDir.ps1.md

`automation/Catzc.Tooling.Core/private/Get-UvVenvDir.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A `uv_venv` tool (e.g. the Azure CLI) lives in its own venv so the package's launcher finds an adjacent
python. All such venvs sit under one user-space root — %LOCALAPPDATA%\catzc\venvs on Windows,
~/.local/share/catzc/venvs on Unix — one subdirectory per tool. The venv's script directory (Scripts on
Windows, bin on Unix) is what goes on PATH.
```
