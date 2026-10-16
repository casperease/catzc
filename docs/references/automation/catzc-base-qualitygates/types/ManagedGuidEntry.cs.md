---
catzc:
  immutable:
    with_body_sha: "66875bbdc9e4"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/ManagedGuidEntry.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: managed-guid-entry-cs
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

# automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One named entry of configs/guids.yml — under `guids:` (a GUID the repository is allowed to carry) or under
`denied:` (a value that is never a legitimate identity). Constructing one MAPS and VALIDATES the entry,
collecting every violation into one throw:
  - the entry name (its map key) is snake_case;
  - the entry is a map carrying only the section's allowed keys (guid, description, and — under `guids:` only —
    sentence; a denied value is never minted for use);
  - `guid` is required and canonical: the lowercase hyphenated 8-4-4-4-12 form;
  - `description` is required and non-empty;
  - `sentence` is optional but non-empty when present (the ConvertTo-Guid source of a minted placeholder).
Value uniqueness spans both sections, so GuidsConfig checks it. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
