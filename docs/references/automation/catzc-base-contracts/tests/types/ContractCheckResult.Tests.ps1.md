---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractCheckResult.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5ac0d6b72629"
    adrs:
      - ADR-AUTO-TYPES#14
      - ADR-REPO-CONTRACT#4
---

# automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractCheckResult' -Tag 'L0', 'logic' {`, written with `#`.

```text
ContractCheckResult is the result of checking one contract asset
([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)): Passed is derived from the findings,
and it renders console-ready ([ADR-AUTO-TYPES#14](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types14)).
```
