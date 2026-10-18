# pwsh/Catzc.Base.Repository/Get-CatzcRunMode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the run mode of the current session: 'source' or 'build'.

### description

The mode is derived, never stored ([ADR-DSGN-RUNMODE#4](../../../adr/design/run-modes.md#rule-adr-dsgn-runmode4)). It is 'source' when the
code root (Get-CatzcModulesRoot) is `<RepositoryRoot>/automation` — the modules were loaded in place by importer.ps1 — and 'build'
otherwise, when the modules were loaded from a built Catzc package by its Import-Catzc.ps1. The two roots are compared as normalized full
paths, case-insensitively, so a trailing separator or a mixed-case drive letter never flips the answer.

### example 1

```powershell
if ((Get-CatzcRunMode) -eq 'build') { ... }
```
