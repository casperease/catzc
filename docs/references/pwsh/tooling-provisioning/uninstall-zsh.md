# pwsh/Tooling.Provisioning/Uninstall-Zsh.ps1

The uninstaller of zsh, the counterpart of `Install-Zsh`: it removes exactly what the install placed and nothing it did not.

## help

### synopsis

Uninstalls the zsh Install-Zsh placed, in Git Bash's tree on Windows and the apt-get package on Linux.

### description

Windows: reads the manifest Install-Zsh wrote inside the Git for Windows tree (the zsh entry's windows_install_dir, which
Get-ScriptInstallDir resolves) and deletes exactly the files it lists, then the folders it lists once they are empty, then the manifest. A
file Git's tree had before Install-Zsh ran is never in the manifest, so it stays
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)). No
admin required.

Linux: removes the package the entry's apt_package names through Uninstall-Tool (apt-get), the manager Install-Zsh installs it through
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)). A zsh
that apt does not own stops the uninstall rather than being removed; the apt step needs root
([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)).

macOS: zsh is the system's /bin/zsh, and Install-Zsh installed nothing, so there is nothing to uninstall.

Idempotent ([ADR-AUTO-IDEM-ALREADYDONEISFINE](../../../drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-alreadydoneisfine)):
without a manifest (Windows) or without zsh (Linux) it reports that there is nothing to do, and a listed file already gone is skipped.

### example 1

```powershell
Uninstall-Zsh
```

## Folder order

Children go before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest folder first. A folder that
still holds anything, such as a file another tool put there, stays.
