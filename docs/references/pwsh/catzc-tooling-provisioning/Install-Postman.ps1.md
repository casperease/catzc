# pwsh/Tooling.Provisioning/Install-Postman.ps1

The installer of the Postman desktop app, a sanctioned latest-version base tool, installed in user space on every platform.

## help

### synopsis

Installs the Postman desktop app (user-space, no admin required).

### description

Windows: Downloads the official installer from dl.pstmn.io and runs it silently. Installs to LOCALAPPDATA\Postman (Squirrel/Electron
default). macOS: brew install --cask postman. Linux: Downloads the tar.gz from dl.pstmn.io and extracts to HOME/.local/Postman. Idempotent —
skips if already installed.

### parameter `Force`

Remove an existing installation before reinstalling.

### example 1

```powershell
Install-Postman
```

### example 2

```powershell
Install-Postman -Force
```

## The download

Postman publishes no per-download checksum and is a sanctioned latest-version base tool, so its download is protected by TLS only, with no
checksum verification ([ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions), the latest
base-tool allowlist).
