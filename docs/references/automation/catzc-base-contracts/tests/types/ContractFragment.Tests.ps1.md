---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractFragment.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4030ff4dfeff"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractFragment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractFragment' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`, written with `#`.

```text
ContractFragment checks that a real file contains a fragment
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): JSON and YAML by key subset, any
other text by its non-blank lines in order. Each rule has a passing and a failing target.
```
