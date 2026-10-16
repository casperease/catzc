---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/types/InspirationEntry.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d4973a08a4f5
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One inspiration of configs/inspiration.yml, as stored: an id, the root it lives at, what it is, and the folders
inside it worth reading. Constructing one MAPS and VALIDATES the entry, and every violation is reported in one
throw, prefixed with the entry's position. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - a mapping whose keys are id, root, description and paths;
  - 'id' is kebab-case (lowercase words joined by '-');
  - 'root' is in communication form, repository-relative or {workspace}-anchored (InspirationRoot.Violations);
  - 'description' is non-blank;
  - 'paths', when present, lists relative paths inside the root, with no anchor.
```
