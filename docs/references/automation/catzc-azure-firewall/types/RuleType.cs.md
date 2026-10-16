---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/types/RuleType.cs.md
    folder: docs/references/automation/catzc-azure-firewall/types
    name: rule-type-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c064865518e4
---

# automation/Catzc.Azure.Firewall/types/RuleType.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Azure.Firewall;`, written with `//`.

```text
The kind of Azure Firewall rule collection an export covers. Parsed case-insensitively from, and
compared back against, the lowercase forms `application` / `network` that the firewall tooling uses.
```
