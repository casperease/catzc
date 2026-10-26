# pwsh/Base.Repository/Get-CatzcRunMode.ps1

The derived answer to whether the session runs the source tree or a built package: `source` or `build`.

## help

### synopsis

Returns the run mode of the current session: 'source' or 'build'.

### description

The mode is derived, never stored ([DDR-RUNMODE-MODEISDERIVED](../../../drs/design/run-modes.md#rule-ddr-runmode-modeisderived)). It is
'source' when the code root (Get-CatzcModulesRoot) is `<RepositoryRoot>/pwsh` — the modules were loaded in place by importer.ps1 — and
'build' otherwise, when the modules were loaded from a built Catzc package by its Import-Catzc.ps1. The two roots are compared as normalized
full paths, case-insensitively, so a trailing separator or a mixed-case drive letter never flips the answer.

### example 1

```powershell
if ((Get-CatzcRunMode) -eq 'build') { ... }
```
