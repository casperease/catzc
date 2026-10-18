# automation/Catzc.Tooling.Provisioning/Install-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs the Postman desktop app (user-space, no admin required).

### description

Windows: Downloads the official installer from dl.pstmn.io and runs it silently. Installs to LOCALAPPDATA\Postman (Squirrel/Electron
default). macOS: brew install --cask postman. Linux: Downloads the tar.gz from dl.pstmn.io and extracts to HOME/.local/Postman. Idempotent —
skips if already installed.

### parameter Force

Remove an existing installation before reinstalling.

### example 1

```powershell
Install-Postman
```

### example 2

```powershell
Install-Postman -Force
```

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
