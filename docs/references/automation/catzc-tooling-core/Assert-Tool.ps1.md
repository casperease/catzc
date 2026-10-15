---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md
    kind: comment-page
    body_sha: cdd2a0b3e570
---

# automation/Catzc.Tooling.Core/Assert-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `if ($config.HasProbes()) {`.

```text
A tool with declared candidate paths is located by the probe, never by its bare name on PATH (for bash on
Windows that name can be the WSL launcher).
```
