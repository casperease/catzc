---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractBindingAssets.ps1.md
    kind: reference
    body_sha: "8e1c23fa59cf"
    adrs:
      - ADR-REPO-CONTRACT#3
      - ADR-REPO-CONTRACT#4
---

# automation/Catzc.Base.Contracts/private/Get-ContractBindingAssets.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Contracts are binding ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)) on two
sets of assets:
- every asset, in both directions, of each unit's current version folder, -Version;
- the provided assets of every other released version folder, any version but the draft 0.0.0. Released folders
  are the pin record: a released provided contract is kept while a consumer pins it, and retiring it means
  deleting its folder ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)).
The depended-on assets of an older released folder are not listed: a depended-on contract follows its outside
platform, so only the current version's expectation binds
([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)).

When -Version names a release, the draft 0.0.0 is not listed. A contracts/ tree that does not list throws, as
Get-Contract does.
```
