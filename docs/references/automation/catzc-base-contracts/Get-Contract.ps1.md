---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Get-Contract.ps1.md
    kind: comment-page
    body_sha: "54b3992ebb4e"
    adrs:
      - ADR-AUTO-PATH#2
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
      - ADR-REPO-CONTRACT#8
---

# automation/Catzc.Base.Contracts/Get-Contract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enumerates contracts/<unit>/<version>/<module>/<path>
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)) and returns one ContractAsset per
file under a module folder. Nothing is registered: the unit, version, and owning module come from the folders; the
kind from the file name ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)); the target
from the path under the module, placed under the module's target root (the repository root unless contracts.yml's
target_roots names one); and the direction from the convention, which a version's contract.yml overrides
for a single asset ([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every path is in
communication form ([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)).

It lists and derives only: it never reads the real files the assets constrain. Files directly under contracts/ (its
README) are not assets, and neither is a released version folder's .frozen record
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). A version folder whose name is not <major>.<minor>.<patch>, a file outside a module folder,
and a contract.yml entry naming no asset each throw. A missing or empty contracts/ gives an empty result.

The addressing mode decides how an asset addresses files
([ADR-REPO-CONTRACT#8](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract8)); only full-path is built, and
selecting a declared mode that is not built throws NotImplementedException before anything is enumerated.
```

## comment:2

Section `.PARAMETER TargetRoot` of the comment-based help.

```text
Each owning module's target root, module name to repository-relative folder; a module it does not name takes the
repository root. Default: contracts.yml's target_roots.
```
