---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-python/Invoke-Pip.ps1.md
    kind: comment-page
    body_sha: "4dffa850ecdd"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Python/Invoke-Pip.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Delegates to Invoke-Uv, so `Invoke-Pip 'install --system requests'` runs `uv pip install --system requests`
against the uv-managed Python. uv is the standard Python handler; installs that target the global
interpreter pass `--system` (see Install-PipTool). uv presence is asserted by Invoke-Uv.
```
