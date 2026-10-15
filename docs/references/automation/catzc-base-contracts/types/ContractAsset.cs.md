---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractAsset.cs.md
    kind: comment-page
    body_sha: "2c35cb9dca6d"
    adrs:
      - ADR-AUTO-PATH#{1,2}
      - ADR-AUTO-TYPES#8
      - ADR-REPO-CONTRACT#{2,6,7}
---

# automation/Catzc.Base.Contracts/types/ContractAsset.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One contract asset under contracts/<unit>/<version>/<module>/<path>
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)), with every fact Get-Contract
derives from its name alone ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
[ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)). A result type, not a config mirror,
so the properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Every path is in communication form ([ADR-AUTO-PATH#1](/docs/adr/automation/path-representation.md#rule-adr-auto-path1),
[ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)): relative, '/'-separated, with no
'.', '..' or empty segment. Construction rejects any other form.
  Unit       the deployable-unit that carries the contract (e.g. catzc)
  Version    the unit's version folder (0.0.0 is the draft)
  Module     the owning catzc module
  Path       the asset's path under its module folder, as named
  AssetPath  the asset file itself, repository-relative (contracts/<unit>/<version>/<module>/<path>)
  Kind       Presence, Fragment, Schema or Sample
  Target     the repository-relative file the asset constrains: the real file for a presence, fragment or schema on a
             file; the sample payload's AssetPath for a schema beside a sample of its name; null for a sample
  Direction  DependedOn or Provided
  IsDirectionOverridden  true when the version's contract.yml set Direction instead of the convention
```
