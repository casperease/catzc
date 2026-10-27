# pwsh/Tooling.Toolchain/Test-DependencyAdvisories.ps1

The dependency scan: osv-scanner over the Python workspace's lock file, which the check resolves from the commit itself, with each advisory
found reported as an issue.

## help

### synopsis

Scans the Python lock file against the OSV advisories and reports every affected package.

### description

uv.lock is per-machine output (gitignored), so without -LockFile the check first runs `uv lock` with the managed uv in the generated Python
workspace, then scans that lock: the input is the commit's resolution, never a lock left behind. osv-scanner runs from the tools.yml pin
(Install-OsvScanner); Tooling is the one place that contacts the advisory feed. Every vulnerable package becomes one issue naming the
package, its version and ecosystem, and the advisory id; exit 1 from the scanner means advisories were found, and any higher exit is a
scanner failure that throws rather than reading as a clean scan.

The scan covers the Python lock only. The extensions under js/ carry no npm dependencies, the tools.yml binaries have no OSV ecosystem, and
the vendored PowerShell modules (PSGallery) have no OSV feed, so none of them is listed as covered.

### parameter `LockFile`

A lock file to scan as it is. Default: the Python workspace's uv.lock, produced first.

### parameter `OutputFolder`

Where the gate report is written. Defaults to the shared report folder.

### parameter `PassThru`

Return the gate result instead of throwing on issues.

### example 1

```powershell
Test-DependencyAdvisories
```
