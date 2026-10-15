---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-AzCli.ps1.md
    kind: reference
    body_sha: "97a33b303625"
    adrs: []
---

# automation/Catzc.Tooling.Toolchain/Install-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Installs az into its own uv venv (`uv venv` + `uv pip install azure-cli`) on every platform — user-space,
no admin. az's launcher runs the python beside it, so it needs a venv with its own interpreter rather than
a uv-tool shim. Requires uv. Idempotent — skips if the correct version is already on PATH.
```
