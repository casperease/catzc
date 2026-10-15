---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md
    kind: comment-page
    body_sha: "3cfc07bb568b"
    adrs:
      - ADR-REPO-CONTRACT#5
---

# automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A released version folder is immutable
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)); its .frozen record holds the
hashes this returns, so a later change to any file shows as a different hash. Every file under the folder counts, at
any depth, contract.yml included; only the record itself, .frozen directly in the folder, does not.

Each hash is the SHA-256 of the file's bytes with every CRLF read as LF. Contract assets are text, and a checkout
with core.autocrlf materialises them with CRLF while another checkout of the same commit has LF; reading line
endings as LF gives every checkout of one commit the same hashes.
```
