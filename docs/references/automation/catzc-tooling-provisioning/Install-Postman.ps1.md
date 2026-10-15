---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Postman.ps1.md
    kind: reference
    body_sha: "92f6ae95f526"
    adrs: []
---

# automation/Catzc.Tooling.Provisioning/Install-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: Downloads the official installer from dl.pstmn.io and runs it
silently. Installs to LOCALAPPDATA\Postman (Squirrel/Electron default).
macOS: brew install --cask postman.
Linux: Downloads the tar.gz from dl.pstmn.io and extracts to
HOME/.local/Postman.
Idempotent — skips if already installed.
```

## comment:2

Above `Write-Message 'Downloading Postman from dl.pstmn.io'`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```

## comment:3

Above `Write-Message 'Downloading Postman from dl.pstmn.io'`.

```text
Postman publishes no per-download checksum and is a sanctioned 'latest' base tool, so this download
is TLS-only — no checksum verification. See ADR controlling-systemwide-deps (latest base-tool allowlist).
```
