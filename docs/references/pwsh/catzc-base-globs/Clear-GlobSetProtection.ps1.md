# automation/Catzc.Base.Globs/Clear-GlobSetProtection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.

### description

The escape hatch for the protected-glob skip ([ADR-REPO-PROTGLOB](../../../adr/repository/protected-globs.md)): the protection map is
session memory, so an importer reload clears it anyway — this clears it without reloading. Use it when a full local rescan is wanted despite
unchanged globsets (e.g. after changing the scan tool itself).

### example 1

```powershell
Clear-GlobSetProtection
```
