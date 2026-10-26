# pwsh/Tooling.Provisioning/Uninstall-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the zsh Install-Zsh placed: in Git Bash's tree on Windows, the apt-get package on Linux.

### description

Windows: reads the manifest Install-Zsh wrote inside the Git for Windows tree (the zsh entry's windows_install_dir, which
Get-ScriptInstallDir resolves) and deletes exactly the files it lists, then the folders it lists once they are empty, then the manifest. A
file Git's tree had before Install-Zsh ran is never in the manifest, so it stays
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)). No
admin required.

Linux: removes the package the entry's apt_package names through Uninstall-Tool (apt-get), the manager Install-Zsh installs it through
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)). A zsh
that apt does not own stops the uninstall rather than being removed; the apt step needs root
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).

macOS: zsh is the system's /bin/zsh, and Install-Zsh installed nothing, so there is nothing to uninstall.

Idempotent ([ADR-AUTO-IDEM-ALREADYDONEISFINE](../../../drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-alreadydoneisfine)):
without a manifest (Windows) or without zsh (Linux) it reports that there is nothing to do, and a listed file already gone is skipped.

### example 1

```powershell
Uninstall-Zsh
```

## comment:1

Above `$directories = [System.Collections.Generic.List[string]]::new([string[]]...`, written with `#`.

```text
Children before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest first. A
folder that still holds anything (a file another tool put there) stays.
```
