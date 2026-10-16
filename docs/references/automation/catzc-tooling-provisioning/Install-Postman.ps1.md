---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Postman.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "603f05ac2c81"
---

# automation/Catzc.Tooling.Provisioning/Install-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Write-Message 'Downloading Postman from dl.pstmn.io'`, written with `#`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```

## comment:2

Above `Write-Message 'Downloading Postman from dl.pstmn.io'` (occurrence 2), written with `#`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```
