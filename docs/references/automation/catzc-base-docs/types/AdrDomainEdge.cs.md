---
catzc:
  immutable:
    with_body_sha: "00f03bae2e00"
    path: docs/references/automation/catzc-base-docs/types/AdrDomainEdge.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: adr-domain-edge-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Docs/types/AdrDomainEdge.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One edge of the ADR domain dependency graph from adrs.yml: From depends on To (one per declared depends_on
link). Built by AdrsConfig from its already-validated domains and exposed as AdrsConfig.Edges; the constructor
holds the edge's own invariant — both ends non-empty and distinct (no self-edge)
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
