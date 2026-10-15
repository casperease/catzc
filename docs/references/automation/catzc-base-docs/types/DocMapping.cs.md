---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/DocMapping.cs.md
    kind: comment-page
    body_sha: "3f1a397e7980"
---

# automation/Catzc.Base.Docs/types/DocMapping.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One explicit README copy-in entry from configs/readme.yml — an authored `source` docs file copied out to
`<folder>/README.md`. Both are repository-root-relative, '/'-separated communication-form paths
(see [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Mirrors a readme.yml mappings entry (snake_case keys).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's Req extraction helper.
```
