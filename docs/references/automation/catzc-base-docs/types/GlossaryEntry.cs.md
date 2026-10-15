---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/GlossaryEntry.cs.md
    kind: comment-page
    body_sha: d364beacd699
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Docs/types/GlossaryEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One concept of the merged controlled vocabulary ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)) as
Get-Glossary returns it: the GlossaryConcept itself, the module whose configs/glossary.yml declares it (Owner), that
source's repo-relative path (SourcePath), and the source's defaulted GlossaryOptions — so a gate or a reader knows
where each term lives and which checks it takes part in without going back to the source. A result type, not a
YAML mirror, so its properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
