---
catzc:
  immutable:
    with_body_sha: "1f8295ac3f17"
    path: docs/references/automation/catzc-base-docs/types/GlossaryOptions.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: glossary-options-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-VOCAB#{2,3}
---

# automation/Catzc.Base.Docs/types/GlossaryOptions.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A glossary source's parameters (the optional configs/glossary.yml `options:` mapping), with every key defaulted:
a source overrides only what differs ([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). `checks`
picks which glossary checks the source's concepts take part in; `scope` and `exclude` bound where its avoided phrasings are scanned; `surfaces` picks which kinds of text
are read there. The default excludes (external language, generated output, vendored code) are ALWAYS added to a
source's own, so no source can scan DORA's research text or out/. Scope and exclude globs are repo-relative
('/'-separated, no leading '/', no drive, no '..', never a URL —
[ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)). Mirrors the YAML mapping
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```

## comment:2

Above `private static IReadOnlyList<string> ClosedList(IDictionary d, string key,...`, written with `//`.

```text
A list option restricted to a closed set; absent -> the whole set. An explicit empty list is allowed (a source
that opts out of every check still gets the structural check).
```
