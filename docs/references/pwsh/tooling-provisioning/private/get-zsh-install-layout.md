# pwsh/Tooling.Provisioning/private/Get-ZshInstallLayout.ps1

A private helper shared by `Install-Zsh` and `Uninstall-Zsh`: the one place that names where zsh lives on Windows.

## help

### synopsis

Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the manifest of the files
Install-Zsh added.

### description

zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides, so it runs on Git's own MSYS2 runtime
(usr\bin\msys-2.0.dll) with no admin rights
([ADR-AUTO-ENTERP-NOLOCALADMIN](../../../../drs/automation/effective-in-enterprises.md#rule-adr-auto-enterp-nolocaladmin)). That tree is
declared once, by the zsh entry's windows_install_dir in tools.yml, and resolved by Get-ScriptInstallDir. The manifest lives inside that
tree, so a tree Install-Git replaces takes the manifest with it. Install-Zsh and Uninstall-Zsh both read the layout here, so they agree on
every path.

### outputs

`[pscustomobject]` { GitHome; Runtime; Executable; Manifest }

### example 1

```powershell
(Get-ZshInstallLayout).Executable
```
