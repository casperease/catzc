# pwsh/Base.Globs/Clear-GlobSetProtection.ps1

The escape hatch of the protected-glob skip ([ADR-REPO-PROTGLOB](../../../drs/repository/protected-globs.md)): it empties the session's
record of green scans, so the next run of every protected scan runs in full.

## help

### synopsis

Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.

### description

The escape hatch for the protected-glob skip ([ADR-REPO-PROTGLOB](../../../drs/repository/protected-globs.md)): the protection map is
session memory, so an importer reload clears it anyway — this clears it without reloading. Use it when a full local rescan is wanted despite
unchanged globsets (e.g. after changing the scan tool itself).

### example 1

```powershell
Clear-GlobSetProtection
```
