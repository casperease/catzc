---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md
    kind: comment-page
    body_sha: "011469838aa1"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The Bash tests run on the bats-core runner checked in at <bashRoot>/.vendor/bats-core/
([ADR-AUTO-BASH](/docs/adr/automation/bash/bash-test-artifacts.md)), so a test run needs no install and no network.
This rebuilds that copy from the pin in bash.yml (bats_version, bats_sha256): it downloads the release's source
archive from GitHub, verifies its SHA-256 (Save-VerifiedDownload), extracts it with tar inside a staging folder by
relative name, and replaces the vendored folder with the runner's files only — bin/, libexec/, lib/ and
LICENSE.md. To move to a new release, change both pins in bash.yml, run this, and commit the result; the files
are LF by .gitattributes, and their executable bits are set in git with git update-index --chmod=+x.
```

## comment:2

Above ``Invoke-Executable "tar -xzf `"$fileName`"" -WorkingDirectory $staging -Silent``.

```text
A relative name inside the staging folder, so no path carries a drive letter's colon (GNU tar reads one as a
remote host).
```
