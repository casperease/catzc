# pwsh/Tooling.Toolchain/Update-BatsVendor.ps1

The refresh of the vendored bats-core test runner: it downloads the release that `bash.yml` pins and rebuilds the vendored folder from it.

## help

### synopsis

Refreshes the vendored bats-core test runner from the release bash.yml pins.

### description

The Bash tests run on the bats-core runner checked in at `<bashRoot>/.vendor/bats-core/`
([ADR-AUTO-BASH](../../../drs/automation/bash/bash-test-artifacts.md)), so a test run needs no install and no network. This rebuilds that
copy from the pin in bash.yml (bats_version, bats_sha256): it downloads the release's source archive from GitHub, verifies its SHA-256
(Save-VerifiedDownload), extracts it with tar inside a staging folder by relative name, and replaces the vendored folder with the runner's
files only — bin/, libexec/, lib/ and LICENSE.md. To move to a new release, change both pins in bash.yml, run this, and commit the result;
the files are LF by .gitattributes, and their executable bits are set in git with git update-index --chmod=+x.

### example 1

```powershell
Update-BatsVendor
```

## Extracting

The archive is extracted by tar run inside the staging folder with a relative name, so that no path carries a drive letter's colon, which
GNU tar reads as a remote host.
