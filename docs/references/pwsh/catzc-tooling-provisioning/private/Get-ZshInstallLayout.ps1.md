# pwsh/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the manifest of the files
Install-Zsh added.

### description

zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides, so it runs on Git's own MSYS2 runtime
(usr\bin\msys-2.0.dll) with no admin rights
([ADR-AUTO-ENTERP#4](../../../../adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). That tree is declared once, by the zsh
entry's windows_install_dir in tools.yml, and resolved by Get-ScriptInstallDir. The manifest lives inside that tree, so a tree Install-Git
replaces takes the manifest with it. Install-Zsh and Uninstall-Zsh both read the layout here, so they agree on every path.

### outputs

`[pscustomobject]` { GitHome; Runtime; Executable; Manifest }

### example 1

```powershell
(Get-ZshInstallLayout).Executable
```
