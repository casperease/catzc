---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Resolve-ContractAsset.ps1.md
    kind: comment-page
    body_sha: "8c19ff1f8355"
    adrs:
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
---

# automation/Catzc.Base.Contracts/private/Resolve-ContractAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Zero ceremony ([ADR-AUTO-ZERO](/docs/adr/automation/zero-ceremony-poka-yoke.md)): the asset declares nothing.
- Kind, from the file name (Get-ContractAssetKind,
  [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)).
- Target: a presence or fragment constrains the real file at its own path under the module's target root; a
  `<path>.schema.json` constrains the real file at `<path>` under that root, unless a sample payload of the same
  `<name>` sits beside it (`<name>.sample.<ext>`), in which case it applies to that sample; a sample payload
  constrains no file ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)).
- Direction, by convention ([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): an
  asset that constrains a real repository file is DependedOn; a sample payload, and the schema that applies to it,
  are Provided. An entry for `<module>/<path>` in -Override replaces the convention.
```

## comment:2

Section `.PARAMETER TargetRoot` of the comment-based help.

```text
The module's target root, repository-relative; the empty path is the repository root. Default: ContractsConfig's
DefaultTargetRoot, the repository root.
```
