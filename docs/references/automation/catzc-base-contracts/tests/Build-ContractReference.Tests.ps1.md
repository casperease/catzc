---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md
    kind: test-asset
    body_sha: "1137b76ff29a"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-README#7
---

# automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Build-ContractReference' -Tag 'L0', 'logic' {`.

```text
Build-ContractReference writes one page per unit, docs/references/contracts/<unit>.md, listing each version folder's
assets with their notes ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)), as a
committed generated page ([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)).
Fixtures are a widget repository in TestDrive ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Build-ContractReference — generated contract reference' -Tag 'L1',...`.

```text
The real contract reference against the real contracts/ tree: the committed pages are what the writer would write now.
Reads only the repository's files.
```
