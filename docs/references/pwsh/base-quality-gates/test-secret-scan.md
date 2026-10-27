# pwsh/Base.QualityGates/Test-SecretScan.ps1

The quality gate for secrets: it reads every tracked text file and fails on a line that carries a secret's shape, a provider key, a private
key, a storage key, a SAS signature or a connection string with a password. The shapes and the skipped paths are configuration
(`secret-patterns.yml`, defaults on `SecretPatternsConfig`), so a new shape is an entry, not code.

## help

### synopsis

Scans the tracked text files for secret shapes and fails on any match.

### description

Lists the tracked files under `-Path`, leaves out the configured skip paths (the fixture trees and the vendored code) and every binary file,
and matches each line against every pattern of the config. A finding names the file, the line and the shape, never the matched text, so the
report does not spread the secret. A placeholder such as `<password>` or `$(secret)` does not match. A quality gate: it ends through
Write-QualityGateReport, which writes out/secret-scan/, prints every issue, and throws once listing them all. It needs the source tree: it
throws in build mode.

### parameter `Path`

The folders whose tracked files are scanned. Default: the whole repository.

### parameter `Config`

The secret-patterns config. Default: `Get-Config -Config secret-patterns`.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/secret-scan`.

### parameter `PassThru`

Return a result object instead of throwing.

### outputs

Throws on any finding; with -PassThru, returns the `[Catzc.Base.Reports.QualityGateResult]`.

### example 1

```powershell
Test-SecretScan
```
