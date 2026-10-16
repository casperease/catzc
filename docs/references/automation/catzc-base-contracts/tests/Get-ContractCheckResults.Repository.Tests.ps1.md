---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "43b280ac9355"
    adrs:
      - ADR-REPO-CONTRACT#4
---

# automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractCheckResults on the repository' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Get-ContractCheckResults runs on the repository's own contracts/ tree
([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)): checking every asset of every
unit's draft returns one result per asset, without error. That every asset passes is the contracts quality gate's work.
```
