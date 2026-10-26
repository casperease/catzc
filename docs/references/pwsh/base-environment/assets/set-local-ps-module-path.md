# pwsh/Base.Environment/assets/Set-LocalPsModulePath.ps1

The asset script that points PowerShell 7's user module path at a local directory when a policy has moved Documents to a network share.

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

It runs before catzc is loaded, so it imports the Loader by its path and writes through the Loader's Write-ImporterMessage, the one
chokepoint that needs no other module ([ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT][r1]), always shown, colour as embedded ANSI.

### example 1

```powershell
& 'automation\Catzc.Base.Environment\assets\Set-LocalPsModulePath.ps1'
```

[r1]: ../../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationchokepoint
