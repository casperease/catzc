---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Read-ContractManifest.ps1.md
    kind: comment-page
    body_sha: "35740dc4e8e6"
    adrs:
      - ADR-REPO-CONTRACT#7
    links: []
---

# automation/Catzc.Base.Contracts/private/Read-ContractManifest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The per-version manifest of [ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7) sits at
contracts/<unit>/<version>/contract.yml. Most version folders carry none, so an absent file is an empty manifest.
The ContractManifest type validates what it reads and throws on a malformed file.
```
