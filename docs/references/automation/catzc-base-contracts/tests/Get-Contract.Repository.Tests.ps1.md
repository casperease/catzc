---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Get-Contract.Repository.Tests.ps1.md
    kind: test-asset
    body_sha: e7811f8682a9
    adrs:
      - ADR-REPO-CONTRACT#2
---

# automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity',...`.

```text
Get-Contract runs on the repository's own contracts/ tree
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)): the shipped layout lists without
error, and every asset it lists carries a kind, a direction, and paths in communication form.
```
