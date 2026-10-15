---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/types/ToolStatusKind.cs.md
    kind: reference
    body_sha: "75f927bfe7bd"
    adrs: []
---

# automation/Catzc.Tooling.Provisioning/types/ToolStatusKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Tooling.Provisioning;`.

```text
A tool's status relative to its tools.yml lock — the verdict of comparing what's installed against what
is required. Load-bearing: Missing/WrongVersion are hard failures, Usable is a "migrate me" hint.
```
