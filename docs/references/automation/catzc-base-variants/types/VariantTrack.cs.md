---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md
    kind: comment-page
    body_sha: "04436d086961"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#6
---

# automation/Catzc.Base.Variants/types/VariantTrack.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One track of the `tracks` variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)): a named
repository root concern, its root folder, its class from the taxonomy, and the file languages its tech-stack is
declared as ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). The entry's fields mirror the
YAML keys, so the properties are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's
YAML key. VariantsConfig validates the entry and builds one; Get-Track returns them.
```

## comment:2

Above `public IReadOnlyList<string> languages { get; }`.

```text
The file-language names of the track's declared tech-stack, in declared order. Empty when the track declares
none. The names are not resolved here: the file-language registry lives in Catzc.Base.Languages.
```
