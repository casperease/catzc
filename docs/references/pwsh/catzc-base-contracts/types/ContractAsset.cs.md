# pwsh/Base.Contracts/types/ContractAsset.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One contract asset under contracts/<unit>/<version>/<module>/<path>
([ADR-REPO-CONTRACT-LAYOUT](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-layout)), with every fact Get-Contract
derives from its name alone ([ADR-REPO-CONTRACT-CONTRACTASSET](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset),
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)). A result type, not a config mirror,
so the properties are PascalCase ([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Every path is in communication form ([ADR-AUTO-PATH-TWOFORMS](/docs/drs/automation/path-representation.md#rule-adr-auto-path-twoforms),
[ADR-AUTO-PATH-COMMUNICATIONFORM](/docs/drs/automation/path-representation.md#rule-adr-auto-path-communicationform)): relative, '/'-separated, with no
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

## comment:2

Above `private static string AssetPathBelowGroup(string value, bool inGroup)`, written with `//`.

```text
An asset's path below its group: its file name, or one folder that sorts the group's assets and the file name. An asset
directly in its version folder has no folder.
```
