---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrDoraCheck.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "55d1103e9a48"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.Docs/types/AdrDoraCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections;`, written with `//`.

```text
The DORA-coverage check's settings (configs/adr-checks.yml, dora_coverage), read by Test-AdrRegistry: every rule set of a
domain has exactly one section linking its ADR in the domain's DORA file (the authoring conventions of the ADR index). Mirrors
the YAML mapping (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built
and validated by AdrChecksConfig.
  mode   — report | gate; default CheckMode's default, gate
  file   — the DORA file's name inside each domain folder; default DefaultFile
  exempt — a map of domain name to the reason it keeps no DORA file
           ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)); default none
  exempt_folders — a map of folder under docs/adr/ (`azure/caf`) to the reason its ADRs take no section in their domain's DORA
           file: they answer a vendor's checklist, grounded in the vendor's reference, not in DORA; default none
```
