---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIgnoreSection.cs.md
    kind: comment-page
    body_sha: cc04eed8d5ac
    adrs: []
    links: []
---

# automation/Catzc.Base.Git/types/GitIgnoreSection.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One section of the gitignore registry (configs/gitignore.yml) — a titled, explained group of ignore
patterns. A section declares EITHER `patterns` (a static list, each a bare string or { pattern, note }) OR
`inject: <provider>` (the patterns are supplied at render time by the caller — e.g. the root-config
registry's committed:false targets), never both. `title` and `why` render as the section's comment block, so
every rule in the generated .gitignore carries its explanation.

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's extraction helpers.
```

## comment:2

Above `public string inject { get; }`.

```text
Name of the render-time pattern provider (e.g. 'rootconfig-committed-false'). Exactly one of
patterns/inject.
```
