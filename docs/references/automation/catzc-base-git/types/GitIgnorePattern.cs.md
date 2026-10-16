---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIgnorePattern.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3d4d7a256c9c"
---

# automation/Catzc.Base.Git/types/GitIgnorePattern.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One pattern line inside a gitignore.yml section — a verbatim git wildmatch pattern with an optional trailing
note (rendered as an aligned inline comment). A section's `patterns` list accepts either a bare string (just
the pattern) or a `{ pattern, note }` mapping; GitIgnoreSection normalizes both into this record. The pattern
text is never rewritten — what the registry says is what .gitignore gets.

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's extraction helpers.
```
