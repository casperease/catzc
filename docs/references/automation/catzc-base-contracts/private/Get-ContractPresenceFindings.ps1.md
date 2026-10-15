---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractPresenceFindings.ps1.md
    kind: reference
    body_sha: "3710d352480d"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/private/Get-ContractPresenceFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The presence check of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6),
which every fragment and schema check runs first. An outside platform reads the path as written, and a case-insensitive
file system (Windows, the default macOS volume) would find a file whose case differs, so the path is walked one
segment at a time against the directory listing and each segment compares ordinally. A segment that exists only in
another case, a missing segment, a folder where the file belongs, and a file where a folder belongs are each one
finding naming the path; a present file gives none.
```
