---
catzc:
  immutable:
    with_body_sha: "9122ef6978ce"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/types/GlossaryEntry.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: glossary-entry-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Docs/types/GlossaryEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One concept of the merged controlled vocabulary ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)) as
Get-Glossary returns it: the GlossaryConcept itself, the module whose configs/glossary.yml declares it (Owner), that
source's repo-relative path (SourcePath), and the source's defaulted GlossaryOptions — so a gate or a reader knows
where each term lives and which checks it takes part in without going back to the source. A result type, not a
YAML mirror, so its properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
