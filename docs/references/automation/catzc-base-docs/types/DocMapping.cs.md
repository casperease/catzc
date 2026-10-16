---
catzc:
  immutable:
    with_body_sha: "5964339922b7"
    path: docs/references/automation/catzc-base-docs/types/DocMapping.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: doc-mapping-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/types/DocMapping.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One explicit README copy-in entry from configs/readme.yml — an authored `source` docs file copied out to
`<folder>/README.md`. Both are repository-root-relative, '/'-separated communication-form paths
(see [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Mirrors a readme.yml mappings entry (snake_case keys).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's Req extraction helper.
```
