# docs/references/automation/catzc-base-globs/Clear-GlobSetProtection.ps1.md

`automation/Catzc.Base.Globs/Clear-GlobSetProtection.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The escape hatch for the protected-glob skip
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): the protection map is session memory, so
an importer reload clears it anyway — this clears it without reloading. Use it when a full local rescan
is wanted despite unchanged globsets (e.g. after changing the scan tool itself).
```
