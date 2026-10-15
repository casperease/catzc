---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractManifest.cs.md
    kind: comment-page
    body_sha: "5aea1a09a150"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-CONTRACT#7
    links: []
---

# automation/Catzc.Base.Contracts/types/ContractManifest.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A version folder's contract.yml, at contracts/<unit>/<version>/contract.yml
([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): the exceptions to the direction
convention. It mirrors the YAML mapping, so the property is snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
  direction  a map of an asset's path under the version folder (<module>/<path>, '/'-separated) to its direction,
             provided or depended-on. Optional; absent means no override.
Construction validates the file and collects every violation into one ArgumentException; an unknown key throws.
That every named asset exists is Get-Contract's check, since only the enumeration knows the assets.
```
