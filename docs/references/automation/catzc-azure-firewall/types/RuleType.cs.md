---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/types/RuleType.cs.md
    kind: reference
    body_sha: "2abb14521a6b"
    adrs: []
---

# automation/Catzc.Azure.Firewall/types/RuleType.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Azure.Firewall;`.

```text
The kind of Azure Firewall rule collection an export covers. Parsed case-insensitively from, and
compared back against, the lowercase forms `application` / `network` that the firewall tooling uses.
```
