---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md
    kind: comment-page
    body_sha: f03cb58cb92b
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$directories = [System.Collections.Generic.List[string]]::new([string[]]...`.

```text
Children before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest first. A
folder that still holds anything (a file another tool put there) stays.
```
