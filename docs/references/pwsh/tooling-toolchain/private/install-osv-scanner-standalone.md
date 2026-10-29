# pwsh/Tooling.Toolchain/private/Install-OsvScannerStandalone.ps1

A private helper of Install-OsvScanner. It installs the osv-scanner release binary on Linux into the user bin, verified against the
published SHA-256.

## help

### synopsis

Installs the newest stable osv-scanner at the locked version into `~/.local/bin`.

### description

Resolves the newest stable google/osv-scanner GitHub release whose version starts with the locked one, picks the `osv-scanner_linux_<arch>`
asset for the machine, and refuses an asset with no published SHA-256 digest. The download is verified (Save-VerifiedDownload) beside the
destination and moved in, so a failed download never leaves a half-written binary. It needs `$env:HOME`. No matching release or asset
throws, naming the pin to bump in tools.yml.

Private helper of Install-OsvScanner; not exported.

### parameter `Version`

The locked version prefix from tools.yml, such as `2.2`.

### example 1

```powershell
Install-OsvScannerStandalone '2.2'
```
