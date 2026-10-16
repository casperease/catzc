---
catzc:
  immutable:
    with_body_sha: e9d35d2769c6
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: file-meta-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-CONF-LOADING#4
      - ADR-REPO-FILEMETA#2
---

# automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The meta-kind registry (file-meta.yml): which kinds of derived fact and of config contribution exist is data, never a list in an engine.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)
```

## comment:2

Above `public bool Selects(FileMetaKind kind, string fileClass, string language) =>...`, written with `//`.

```text
True when the kind applies to the file, by the file's class (its kind, or kind/subkind, from the file-kinds registry) and its
language (null when no language claims it).
```
