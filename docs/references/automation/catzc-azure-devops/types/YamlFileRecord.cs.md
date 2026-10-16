---
catzc:
  immutable:
    with_body_sha: "5f49b3c80d14"
    path: docs/references/automation/catzc-azure-devops/types/YamlFileRecord.cs.md
    folder: docs/references/automation/catzc-azure-devops/types
    name: yaml-file-record-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/types/YamlFileRecord.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One YAML file discovered by scanning a repository, with the classification derived from its content.
The filesystem-side view of a pipeline/template (before any cross-reference to ADO registration).
```

## comment:2

Above `public string[] TopLevelKeys { get; }`, written with `//`.

```text
The file's top-level YAML keys — the evidence the classification was derived from. Never null (an
empty array when there were none).
```

## comment:3

Above `public YamlFileRecord(string root, string path, string relativePath, string...`, written with `//`.

```text
Classification/templateType are taken as strings and parsed to enums, so a producer (or a test mock)
that supplies string literals binds without first converting to enum values.
```
