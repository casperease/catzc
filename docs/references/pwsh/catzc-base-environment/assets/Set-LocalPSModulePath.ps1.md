# pwsh/Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Redirects PowerShell 7's user module path from a network share to a local directory.

### description

Enterprise GPOs often redirect the Documents folder to a DFS/UNC share. PowerShell stores user modules under Documents\PowerShell\Modules,
causing network scans on every module lookup, tab completion, and command discovery.

This script writes a user-scope powershell.config.json in the PS7 user config directory (Documents\PowerShell, even if on DFS). PS7 reads
this single file at startup to override the CurrentUser module path. One file read is fast — the slowness comes from recursive module
scanning, not reading a config file.

No admin required. Idempotent — safe to run repeatedly.

It runs before catzc is loaded, so it writes through Write-Information directly rather than the writer chokepoint — the same information
stream ([ADR-PWSH-ANNOUNCE#1](../../../../adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)), always shown, colour as embedded
ANSI.

### example 1

```powershell
& 'automation\Catzc.Base.Environment\assets\Set-LocalPSModulePath.ps1'
```
