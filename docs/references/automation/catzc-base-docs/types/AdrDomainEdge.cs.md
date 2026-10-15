---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrDomainEdge.cs.md
    kind: comment-page
    body_sha: "42edbcd54910"
    adrs:
      - ADR-AUTO-TYPES#9
    links: []
---

# automation/Catzc.Base.Docs/types/AdrDomainEdge.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One edge of the ADR domain dependency graph from adrs.yml: From depends on To (one per declared depends_on
link). Built by AdrsConfig from its already-validated domains and exposed as AdrsConfig.Edges; the constructor
holds the edge's own invariant — both ends non-empty and distinct (no self-edge)
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
