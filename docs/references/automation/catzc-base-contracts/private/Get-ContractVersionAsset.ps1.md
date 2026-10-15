---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md
    kind: comment-page
    body_sha: "97c26c9ba5d6"
    adrs:
      - ADR-PWSH-ENUM#3
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#7
---

# automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A version folder, contracts/<unit>/<version>/, holds one folder per owning module and, optionally, its contract.yml
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2),
[ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every file under a module folder
is an asset, at any depth. A released version folder also holds its .frozen record, the hash of each of its files
that Publish-ContractRelease writes when it freezes the draft
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)); it is not an asset. Any other
file at the version level, and a .frozen in the draft 0.0.0, has no owning module, and a contract.yml entry that
names no asset overrides nothing; both throw, naming the file or the entry. Each asset's target sits under its
module's target root, which ContractsConfig.ResolveTargetRoot picks from -TargetRoot
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)). Assets come in ordinal
order of module, then path.
```

## comment:2

Above `$files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
asset of the version is listed, so no name is pruned and no depth drops one.
```
