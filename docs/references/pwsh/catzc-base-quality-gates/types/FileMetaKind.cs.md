# pwsh/Catzc.Base.QualityGates/types/FileMetaKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of the meta-kind registry; the defaults of an omitted key are declared here, once.
[ADR-REPO-FILEMETA-METAKIND](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
```

## comment:2

Above `public static string ConventionName(string id, FileMetaDirection direction)`, written with `//`.

```text
The function a module subscribes by default: Get-<Id>FileMetaFact, or Get-<Id>MarkdownConfigContribution
([ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction)).
```

## comment:3

Above `public const string DefaultSection = "immutable";`, written with `//`.

```text
The parts of the meta block an imprint kind writes into: the place facts, or the outgoing edges
([ADR-REPO-FILEMETA-FILEISNODE](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)).
```
