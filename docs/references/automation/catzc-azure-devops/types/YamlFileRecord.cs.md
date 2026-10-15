# docs/references/automation/catzc-azure-devops/types/YamlFileRecord.cs.md

`automation/Catzc.Azure.DevOps/types/YamlFileRecord.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One YAML file discovered by scanning a repository, with the classification derived from its content.
The filesystem-side view of a pipeline/template (before any cross-reference to ADO registration).
```

## comment:2

Above `public string[] TopLevelKeys { get; }`.

```text
The file's top-level YAML keys — the evidence the classification was derived from. Never null (an
empty array when there were none).
```

## comment:3

Above `public YamlFileRecord(string root, string path, string relativePath, string...`.

```text
Classification/templateType are taken as strings and parsed to enums, so a producer (or a test mock)
that supplies string literals binds without first converting to enum values.
```
