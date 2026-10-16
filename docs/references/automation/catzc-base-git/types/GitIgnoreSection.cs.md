---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIgnoreSection.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: dd8b0e44f671
---

# automation/Catzc.Base.Git/types/GitIgnoreSection.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

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

Above `public string inject { get; }`, written with `//`.

```text
Name of the render-time pattern provider (e.g. 'rootconfig-committed-false'). Exactly one of
patterns/inject.
```
