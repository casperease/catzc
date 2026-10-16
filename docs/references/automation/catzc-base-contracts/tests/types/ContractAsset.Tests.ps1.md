---
catzc:
  immutable:
    with_body_sha: "60a1ce75aa03"
    repo_status: locked
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md
    folder: docs/references/automation/catzc-base-contracts/tests/types
    name: contract-asset-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-PATH#2
---

# automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractAsset' -Tag 'L0', 'logic' {`, written with `#`.

```text
ContractAsset holds every derived fact of one contract asset, with its paths in communication form
([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)).
```
