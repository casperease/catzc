---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractFreezeFindings.ps1.md
    kind: comment-page
    body_sha: "6f8913be258b"
    adrs:
      - ADR-REPO-CONTRACT#5
    links: []
---

# automation/Catzc.Base.Contracts/private/Get-ContractFreezeFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A released version folder is immutable
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). Publish-ContractRelease
freezes it with a .frozen record, one line per file, '<sha256>  <path>', after '#' comment lines; this compares the
record with the folder's files as Get-ContractFileHashes hashes them now, and returns one finding per defect:
a missing record, a malformed or repeated record line, and every file changed, added or removed since the freeze.
No finding means the folder is intact. The draft, 0.0.0, is never frozen, so it is never given here.
```
