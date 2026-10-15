---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/GuidsConfig.cs.md
    kind: comment-page
    body_sha: "686a74b070f4"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.QualityGates/types/GuidsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The managed-GUID registry, configs/guids.yml: every GUID literal the repository carries, each a named, described
entry (`guids:`), plus the non-allow list of values that are never a legitimate identity (`denied:`).
Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.QualityGates.GuidsConfig), so
Get-Config -Config guids returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level keys 'denied' (optional) and 'guids' (required; an empty map or no value allowed) — the
    schema is strict, so a stray key cannot quietly linger;
  - each section is a map of name -> ManagedGuidEntry, each entry well-formed;
  - guid values are unique across all entries — a GUID has exactly one name, and a denied value can never also
    be registered.
That every registered GUID appears in tracked text (and no unregistered or denied one does) is the managed-guid
integrity test's job, not load's.
```
