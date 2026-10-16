---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/types/YamlInventoryRecord.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "81fc4f9ebc94"
---

# automation/Catzc.Azure.DevOps/types/YamlInventoryRecord.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One scanned YAML file joined to ADO registration data — the inventory row that answers "does this file
back a registered pipeline?". Carries the filesystem-side fields of a YamlFileRecord plus the
registration-side fields, which are null/absent when the file backs no registered pipeline.
```

## comment:2

Above `public YamlInventoryRecord(string root, string path, string relativePath,...`, written with `//`.

```text
A flat constructor over primitives (not a YamlFileRecord), so a test mocking the file scan with a
plain pscustomobject still binds. Classification/templateType are taken as strings and parsed to enums.
```
