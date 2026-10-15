---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Save-VerifiedDownload.ps1.md
    kind: reference
    body_sha: "7fc7c634e099"
    adrs: []
---

# automation/Catzc.Tooling.Core/Save-VerifiedDownload.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Downloads -Uri to -OutFile, computes the SHA-256, and asserts it equals -Sha256 (case-insensitive,
'sha256:' prefix tolerated). On mismatch the partial/bad file is deleted and the call throws — a
download is never left on disk for a caller to execute unverified. Returns the verified path.

The expected hash comes from the caller. For a sanctioned 'latest' base tool (e.g. git) it is the
publisher's own published hash for the resolved version — the GitHub release asset `digest`. (Tools
whose publisher provides no checksum, e.g. Postman, are TLS-only and do not use this helper.) See
ADR controlling-systemwide-deps.
```
