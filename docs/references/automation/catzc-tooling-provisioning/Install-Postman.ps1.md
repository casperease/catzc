---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Postman.ps1.md
    kind: comment-page
    body_sha: b74fbfac47a1
---

# automation/Catzc.Tooling.Provisioning/Install-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Write-Message 'Downloading Postman from dl.pstmn.io'`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```

## comment:5

Above `Write-Message 'Downloading Postman from dl.pstmn.io'`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```
