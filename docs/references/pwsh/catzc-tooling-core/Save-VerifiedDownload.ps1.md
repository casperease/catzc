# pwsh/Tooling.Core/Save-VerifiedDownload.ps1

The download helper that never leaves an unverified file on disk: it fetches a file over HTTPS, checks its SHA-256 against the hash the
caller supplies, and deletes the file and throws on a mismatch.

## help

### synopsis

Downloads a file over HTTPS and verifies its SHA-256, rejecting a mismatch.

### description

Downloads -Uri to -OutFile, computes the SHA-256, and asserts it equals -Sha256 (case-insensitive, 'sha256:' prefix tolerated). On mismatch
the partial/bad file is deleted and the call throws — a download is never left on disk for a caller to execute unverified. Returns the
verified path.

The expected hash comes from the caller. For a sanctioned 'latest' base tool (e.g. git) it is the publisher's own published hash for the
resolved version — the GitHub release asset `digest`. (Tools whose publisher provides no checksum, e.g. Postman, are TLS-only and do not use
this helper.) See ADR controlling-systemwide-deps.

### parameter `Uri`

The download URL.

### parameter `OutFile`

Destination path.

### parameter `Sha256`

Expected SHA-256, hex (a leading 'sha256:' is stripped).

### example 1

```powershell
Save-VerifiedDownload -Uri $asset.browser_download_url -OutFile $exePath -Sha256 $asset.digest
```
