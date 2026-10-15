# docs/references/automation/catzc-base-environment/assets/Set-LocalPSModulePath.ps1.md

`automation/Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim.
The file keeps one line and a link per section (Export-Comments),
and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enterprise GPOs often redirect the Documents folder to a DFS/UNC share.
PowerShell stores user modules under Documents\PowerShell\Modules,
causing network scans on every module lookup, tab completion, and
command discovery.

This script writes a user-scope powershell.config.json in the PS7
user config directory (Documents\PowerShell, even if on DFS). PS7
reads this single file at startup to override the CurrentUser module
path. One file read is fast — the slowness comes from recursive
module scanning, not reading a config file.

No admin required. Idempotent — safe to run repeatedly.

It runs before catzc is loaded, so it writes through Write-Information directly rather than the writer
chokepoint — the same information stream
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)), always
shown, colour as embedded ANSI.
```

## comment:2

Above `$userConfigDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Pow...`.

```text
Use GetFolderPath, not $PROFILE — admin sessions resolve $PROFILE to a
different (local) path than the normal user session (DFS).
```
