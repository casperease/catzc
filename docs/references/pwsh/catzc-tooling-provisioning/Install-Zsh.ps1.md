# pwsh/Tooling.Provisioning/Install-Zsh.ps1

The installer of zsh: the pinned MSYS2 package unpacked into Git Bash's tree on Windows, the distribution package on Linux, and the system's own
zsh on macOS.

## help

### synopsis

Installs zsh (user-space on Windows, into Git Bash's tree; apt-get on Linux; the system's on macOS).

### description

Windows: installs the MSYS2 zsh package that tools.yml pins (`zsh`: msys2_url and msys2_sha256) into the Git for Windows tree Install-Git
provides (the entry's windows_install_dir), so zsh runs on Git Bash's own MSYS2 runtime. No admin required
([ADR-AUTO-ENTERP-NOLOCALADMIN](../../../drs/automation/effective-in-enterprises.md#rule-adr-auto-enterp-nolocaladmin)). The package is
downloaded through Save-VerifiedDownload and its SHA-256 checked before anything is extracted
([ADR-AUTO-PKGMGR-VERIFYDOWNLOADS](../../../drs/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr-verifydownloads)); Windows'
own tar reads the zstd archive. Only the files Git's tree lacks are copied, and their list is recorded in a manifest inside the tree before
the copy starts, so Uninstall-Zsh removes exactly those
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)). PATH
is left alone: zsh is located by its tools.yml candidates.

Install-Git is a prerequisite, asserted and never run from here: without Git's tree the install stops and names Install-Git. Install-Git
-Force replaces Git's whole tree, zsh included, so run Install-Zsh again after it (Install-DevBoxTools runs them in that order).

Linux: installs the distribution's package that the entry's apt_package names, through Install-Tool (apt-get), when zsh is missing
([ADR-AUTO-PKGMGR-PLATFORMNATIVEMANAGERS](../../../drs/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr-platformnativemanagers);
[PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)). That
needs root or passwordless sudo (Test-IsAdministrator), so tools.yml marks the entry linux_admin_only and a non-elevated Install-DevBoxTools
skips it and says so. Either way it then asserts zsh at the pinned version.

macOS: zsh ships as /bin/zsh, so Install-Zsh asserts it is present at the pinned version and installs nothing.

Idempotent ([ADR-AUTO-IDEM-CHECKBEFOREACTING](../../../drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-checkbeforeacting)):
skips when the pinned package is already installed, and on Linux when zsh is already present at the pinned version, with no root asked for.
A zsh from another package (Windows) or at another version (Linux) stops the install unless -Force is passed.

### parameter `Force`

Windows: uninstall the zsh Install-Zsh placed (Uninstall-Zsh) and install the pinned package again. Linux: replace a zsh at another version
through Install-Tool -Force. No effect on macOS.

### example 1

```powershell
Install-Zsh
```

### example 2

```powershell
Install-Zsh -Force
```

## On Linux

The shared apt installer, `Install-Tool`, installs the package the entry's `apt_package` names. It checks presence before asking for root, so
a box that has zsh at the pinned version installs nothing.

## On Windows

Past the early return, an existing manifest is either a `-Force` replacement or an install that was cut short. Either way its files go first,
so the new manifest lists every file this package owns. An MSYS2 package keeps its metadata files (`.PKGINFO` and its siblings) at the archive
root and its payload under `etc/` and `usr/`; only the payload belongs in Git's tree.
