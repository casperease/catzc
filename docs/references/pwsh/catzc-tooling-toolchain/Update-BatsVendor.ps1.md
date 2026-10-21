# pwsh/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above ``Invoke-Executable "tar -xzf `"$fileName`"" -WorkingDirectory $staging -Silent``, written with `#`.

```text
A relative name inside the staging folder, so no path carries a drive letter's colon (GNU tar reads one as a
remote host).
```
