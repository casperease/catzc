---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/types/ToolStatusKind.cs.md
    kind: comment-page
    body_sha: b8df542dc6b0
---

# automation/Catzc.Tooling.Provisioning/types/ToolStatusKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Tooling.Provisioning;`, written with `//`.

```text
A tool's status relative to its tools.yml lock — the verdict of comparing what's installed against what
is required. Load-bearing: Missing/WrongVersion are hard failures, Usable is a "migrate me" hint.
```
