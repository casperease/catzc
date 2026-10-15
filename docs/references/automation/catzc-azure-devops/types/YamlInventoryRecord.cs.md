# docs/references/automation/catzc-azure-devops/types/YamlInventoryRecord.cs.md

`automation/Catzc.Azure.DevOps/types/YamlInventoryRecord.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One scanned YAML file joined to ADO registration data — the inventory row that answers "does this file
back a registered pipeline?". Carries the filesystem-side fields of a YamlFileRecord plus the
registration-side fields, which are null/absent when the file backs no registered pipeline.
```

## comment:2

Above `public YamlInventoryRecord(string root, string path, string relativePath,...`.

```text
A flat constructor over primitives (not a YamlFileRecord), so a test mocking the file scan with a
plain pscustomobject still binds. Classification/templateType are taken as strings and parsed to enums.
```
