---
catzc:
  immutable:
    with_body_sha: c2dd9b6b484b
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: file-meta-kind-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#{2,4,13}
---

# automation/Catzc.Base.QualityGates/types/FileMetaKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of the meta-kind registry; the defaults of an omitted key are declared here, once.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:2

Above `public static string ConventionName(string id, FileMetaDirection direction)`, written with `//`.

```text
The function a module subscribes by default: Get-<Id>FileMetaFact, or Get-<Id>MarkdownConfigContribution
([ADR-REPO-FILEMETA#4](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta4)).
```

## comment:3

Above `public const string DefaultSection = "immutable";`, written with `//`.

```text
The parts of the meta block an imprint kind writes into: the place facts, or the outgoing edges
([ADR-REPO-FILEMETA#13](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta13)).
```
