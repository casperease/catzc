---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Zsh.ps1.md
    kind: comment-page
    body_sha: "40c47010a1c0"
    adrs:
      - ADR-AUTO-ENTERP#4
      - ADR-AUTO-IDEM#1
      - ADR-AUTO-PKGMGR#5
      - ADR-AUTO-PKGMGR#6
      - ADR-AUTO-REMOVE#2
      - ADR-PRIN-CONFIG#1
---

# automation/Catzc.Tooling.Provisioning/Install-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: installs the MSYS2 zsh package that tools.yml pins (`zsh`: msys2_url and msys2_sha256) into the Git for
Windows tree Install-Git provides (the entry's windows_install_dir), so zsh runs on Git Bash's own MSYS2 runtime.
No admin required ([ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). The package
is downloaded through Save-VerifiedDownload and its SHA-256 checked before anything is extracted
([ADR-AUTO-PKGMGR#6](/docs/adr/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr6)); Windows' own tar
reads the zstd archive. Only the files Git's tree lacks are copied, and their list is recorded in a manifest inside
the tree before the copy starts, so Uninstall-Zsh removes exactly those
([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)). PATH is left alone: zsh
is located by its tools.yml candidates.

Install-Git is a prerequisite, asserted and never run from here: without Git's tree the install stops and names
Install-Git. Install-Git -Force replaces Git's whole tree, zsh included, so run Install-Zsh again after it
(Install-DevBoxTools runs them in that order).

Linux: installs the distribution's package that the entry's apt_package names, through Install-Tool (apt-get), when
zsh is missing ([ADR-AUTO-PKGMGR#5](/docs/adr/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr5);
[ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). That needs root or
passwordless sudo (Test-IsAdministrator), so tools.yml marks the entry linux_admin_only and a non-elevated
Install-DevBoxTools skips it and says so. Either way it then asserts zsh at the pinned version.

macOS: zsh ships as /bin/zsh, so Install-Zsh asserts it is present at the pinned version and installs nothing.

Idempotent ([ADR-AUTO-IDEM#1](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1)): skips when
the pinned package is already installed, and on Linux when zsh is already present at the pinned version, with no
root asked for. A zsh from another package (Windows) or at another version (Linux) stops the install unless -Force
is passed.
```

## comment:2

Section `.PARAMETER Force` of the comment-based help.

```text
Windows: uninstall the zsh Install-Zsh placed (Uninstall-Zsh) and install the pinned package again. Linux: replace
a zsh at another version through Install-Tool -Force. No effect on macOS.
```

## comment:3

Above `Install-Tool -Tool zsh -Force:$Force`.

```text
The shared apt installer: it installs the package the entry's apt_package names, and checks presence before
asking for root, so a box that has zsh at the pinned version installs nothing.
```

## comment:4

Above `if ($installed) {`.

```text
Past the early return, a manifest is either a -Force replacement or an install that was cut short: either way its
files go first, so the new manifest lists every file this package owns.
```

## comment:5

Above `foreach ($metadata in [System.IO.Directory]::GetFiles($staging)) {`.

```text
An MSYS2 package keeps its metadata files (.PKGINFO and its siblings) at the archive root and its payload under
etc/ and usr/: only the payload belongs in Git's tree.
```

## comment:6

Above `Install-Tool -Tool zsh -Force:$Force`.

```text
The shared apt installer: it installs the package the entry's apt_package names, and checks presence before
asking for root, so a box that has zsh at the pinned version installs nothing.
```

## comment:7

Above `if ($installed) {`.

```text
Past the early return, a manifest is either a -Force replacement or an install that was cut short: either way its
files go first, so the new manifest lists every file this package owns.
```

## comment:8

Above `foreach ($metadata in [System.IO.Directory]::GetFiles($staging)) {`.

```text
An MSYS2 package keeps its metadata files (.PKGINFO and its siblings) at the archive root and its payload under
etc/ and usr/: only the payload belongs in Git's tree.
```
