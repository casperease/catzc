---
catzc:
  immutable:
    with_body_sha: c77d074b1dc0
    path: docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md
    folder: docs/references/automation/catzc-base-variants/types
    name: variant-track-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#6
---

# automation/Catzc.Base.Variants/types/VariantTrack.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One track of the `tracks` variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)): a named
repository root concern, its root folder, its class from the taxonomy, and the file languages its tech-stack is
declared as ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). The entry's fields mirror the
YAML keys, so the properties are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's
YAML key. VariantsConfig validates the entry and builds one; Get-Track returns them.
```

## comment:2

Above `public IReadOnlyList<string> languages { get; }`, written with `//`.

```text
The file-language names of the track's declared tech-stack, in declared order. Empty when the track declares
none. The names are not resolved here: the file-language registry lives in Catzc.Base.Languages.
```
