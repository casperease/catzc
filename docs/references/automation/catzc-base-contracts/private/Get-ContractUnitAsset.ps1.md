---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractUnitAsset.ps1.md
    kind: reference
    body_sha: "7b34bb7fa703"
    adrs:
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
---

# automation/Catzc.Base.Contracts/private/Get-ContractUnitAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A unit folder, contracts/<unit>/, holds only version folders named <major>.<minor>.<patch>
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)); 0.0.0 is the unit's draft
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). Every version folder name is
checked, selected or not, so a misnamed folder throws on any listing; a file directly in the unit folder throws too.
A selection that matches no version folder gives nothing. Versions come in ordinal order.
```

## comment:2

Section `.PARAMETER TargetRoot` of the comment-based help.

```text
The target roots, module name to repository-relative folder
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). A module it does not name
takes the repository root.
```
