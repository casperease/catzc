---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/DocPattern.cs.md
    kind: comment-page
    body_sha: "4bcb40c321e0"
    adrs: []
---

# automation/Catzc.Base.Docs/types/DocPattern.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One glob-based README source convention from configs/readme.yml — every folder matched by `glob` derives its
README source from `source`, a template whose `{kebab}` placeholder expands to the matched folder's leaf name
lowercased with dots turned to hyphens. Both are repository-root-relative, '/'-separated communication-form
values (see [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Mirrors a readme.yml patterns entry (snake_case keys).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary over
its own properties and its constructor uses the base's Req extraction helper.
```
