---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md
    kind: comment-page
    body_sha: "4cc432932323"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Variants/types/VariantAspect.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Variants;`, written with `//`.

```text
One aspect of a track's ordered classification in the `aspects` variant (configs/variants.yml,
[ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): a single-key `{name: [patterns]}` entry, patterns relative
to the unit root. The YAML key is the aspect's name (data, not a fixed field), so the record is not a key mirror
and keeps .NET PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
VariantsConfig validates the entry in its track's context (name, order, catch-all) and builds one; Get-Aspect
returns them.
```

## comment:2

Above `public string[] Patterns { get; }`, written with `//`.

```text
The aspect's glob patterns, relative to the unit root. The last aspect of a track is the bare '**'
catch-all remainder.
```
