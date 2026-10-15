---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md
    kind: comment-page
    body_sha: "9a5fb898f78d"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Variants/types/VariantAspect.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Variants;`.

```text
One aspect of a track's ordered classification in the `aspects` variant (configs/variants.yml,
[ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): a single-key `{name: [patterns]}` entry, patterns relative
to the unit root. The YAML key is the aspect's name (data, not a fixed field), so the record is not a key mirror
and keeps .NET PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
VariantsConfig validates the entry in its track's context (name, order, catch-all) and builds one; Get-Aspect
returns them.
```

## comment:2

Above `public string[] Patterns { get; }`.

```text
The aspect's glob patterns, relative to the unit root. The last aspect of a track is the bare '**'
catch-all remainder.
```
